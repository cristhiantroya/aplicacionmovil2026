import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../db/app_database.dart';
import '../services/product_service.dart';
import '../services/api_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint

const int _maxIntentos = 5;

class SyncService {
  final AppDatabase db;
  SyncService(this.db);

  Future<bool> get hayConexion async {
    final r = await Connectivity().checkConnectivity();
    return !r.contains(ConnectivityResult.none);
  }

  /// Encola una creación de producto offline (idempotente: clienteId único).
  Future<void> encolarCrearProducto(String clienteId, Map<String, dynamic> payload) async {
    await db.into(db.operacionesPendientes).insert(OperacionesPendientesCompanion.insert(
          clienteId: clienteId,
          tipo: 'crear_producto',
          payloadJson: jsonEncode(payload),
          creadoEn: DateTime.now(),
        ));
  }

  /// Procesa la cola con reintentos de espera creciente (backoff
  /// exponencial: 1s, 2s, 4s, 8s...) y un máximo de intentos.
  Future<void> procesarCola() async {
    debugPrint('SYNC: iniciando procesamiento');
    
    if (!await hayConexion) {
      debugPrint('SYNC: sin conexión, cancelando procesamiento');
      return;
    }

    final pendientes = await db.select(db.operacionesPendientes).get();
    debugPrint('SYNC: ${pendientes.length} operaciones pendientes');
    
    for (final op in pendientes) {
      debugPrint('SYNC: procesando ${op.clienteId}, intento ${op.intentos + 1}/$_maxIntentos');
      
      if (op.intentos >= _maxIntentos) {
        debugPrint('SYNC: ${op.clienteId} superó máximo de intentos, abandonado');
        continue; // se abandona, queda visible como fallida
      }

      try {
        final data = jsonDecode(op.payloadJson) as Map<String, dynamic>;
        final apiService = ApiService();
        final productService = ProductService(apiService);

        debugPrint('SYNC: enviando producto ${op.clienteId} al servidor');
        final result = await productService.createProduct(
          nombre: data['nombre'],
          descripcion: data['descripcion'],
          precio: (data['precio'] as num).toDouble(),
          estadoUso: data['estado_uso'],
          categoria: data['categoria'],
          ubicacion: data['ubicacion'],
        );

        debugPrint('SYNC: producto sincronizado exitosamente - ID: ${result['product']['id_producto']}');

        // Éxito: marcar la fila local con el id real del servidor y
        // limpiar la operación de la cola.
        await (db.update(db.productosLocal)..where((t) => t.clienteId.equals(op.clienteId)))
            .write(ProductosLocalCompanion(
          idProducto: Value(result['product']['id_producto']),
          pendienteEnvio: const Value(false),
          actualizadoEn: Value(DateTime.parse(result['product']['creado_en'])),
        ));
        await (db.delete(db.operacionesPendientes)..where((t) => t.clienteId.equals(op.clienteId))).go();
        
        debugPrint('SYNC: ${op.clienteId} eliminado de la cola');
      } catch (e) {
        debugPrint('SYNC: error al procesar ${op.clienteId}: $e');
        
        // Verificar si es un error que no merece reintento
        if (e is DioException && [400, 403, 422].contains(e.response?.statusCode)) {
          debugPrint('SYNC: ${op.clienteId} error no recuperable (${e.response?.statusCode}), eliminando de cola');
          // Error de datos/permisos: reintentar no lo arregla. Se descarta.
          await (db.delete(db.operacionesPendientes)..where((t) => t.clienteId.equals(op.clienteId))).go();
          continue;
        }
        
        // Backoff: espera creciente antes del próximo intento global,
        // e incrementa el contador de esta operación.
        final espera = Duration(seconds: (1 << op.intentos)); // 1,2,4,8,16s
        debugPrint('SYNC: ${op.clienteId} reintento en ${espera.inSeconds} segundos');
        await (db.update(db.operacionesPendientes)..where((t) => t.clienteId.equals(op.clienteId)))
            .write(OperacionesPendientesCompanion(intentos: Value(op.intentos + 1)));
        await Future.delayed(espera);
      }
    }
    
    debugPrint('SYNC: procesamiento finalizado');
  }
}


void configurarListenerDeConectividad(SyncService syncService) {
  Connectivity().onConnectivityChanged.listen((result) {
    debugPrint('CONNECTIVITY CAMBIO: $result');

    if (!result.contains(ConnectivityResult.none)) {
      debugPrint('LLAMANDO A PROCESAR COLA');
      syncService.procesarCola();
    } else {
      debugPrint('CONNECTIVITY: Sin conexión detectada');
    }
  });
}