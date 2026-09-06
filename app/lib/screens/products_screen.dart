import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../widgets/products_list_section_assembled.dart';
import '../state/remote_state.dart';
import '../db/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Pantalla de listado de productos (antes era parte de HomeScreen;
/// ahora es la pantalla raíz de la pestaña /home dentro del shell).
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AppDatabase _db = AppDatabase();
  RemoteState<List<Product>> _state = const RemoteLoading();
  DateTime? _ultimaActualizacionLocal;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // Nuevo: Suscripción para cambios de conectividad
  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _loadProducts();

    // Nuevo: Escuchar cambios en la conectividad
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    // Nuevo: Cancelar la suscripción
    _connectivitySubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _state = const RemoteLoading();
    });

    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);

      final products = await productService.getProducts();
      await (_db.delete(
  _db.productosLocal,
)..where(
  (t) => t.pendienteEnvio.equals(false),
)).go();

      // Guardar productos en la base de datos local
      for (final p in products) {
        await _db.into(_db.productosLocal).insertOnConflictUpdate(
          ProductosLocalCompanion.insert(
            clienteId: 'srv-${p.idProducto}',
            idProducto: Value(p.idProducto),
            nombre: p.nombre,
            precio: p.precio,
            estadoUso: p.estadoUso,
            categoria: Value(p.categoria),
            ubicacion: Value(p.ubicacion),
            actualizadoEn: DateTime.now(),
          ),
        );
      }

      setState(() {
        _ultimaActualizacionLocal = null; // hay datos frescos del servidor
        _state =
            products.isEmpty ? const RemoteEmpty() : RemoteSuccess(products);
      });
    } catch (e) {
      try {
        final locales = await _db.select(_db.productosLocal).get();

        if (locales.isNotEmpty) {
          _ultimaActualizacionLocal = locales
              .map((p) => p.actualizadoEn)
              .reduce((a, b) => a.isAfter(b) ? a : b);
        }

        final productsLocales = locales
            .map(
              (p) => Product(
                idProducto: p.idProducto ?? 0,
                idUsuario: 0,
                nombre: p.nombre,
                descripcion: 'Producto almacenado localmente',
                precio: p.precio,
                estadoUso: p.estadoUso,
                estadoDisponibilidad:
                    p.pendienteEnvio ? 'pendiente' : 'disponible',
                categoria: p.categoria,
                ubicacion: p.ubicacion,
                imagenes: const [],
                creadoEn: p.actualizadoEn,
              ),
            )
            .toList();

        setState(() {
          _state = productsLocales.isEmpty
              ? const RemoteEmpty()
              : RemoteSuccess(productsLocales);
        });
      } catch (_) {
        setState(() {
          _state = RemoteFailure(e.toString());
        });
      }
    }
  }

  RemoteState<List<Product>> get _filteredState {
    final s = _state;
    if (s is! RemoteSuccess<List<Product>>) return s;
    if (_searchQuery.trim().isEmpty) return s;
    final query = _searchQuery.trim().toLowerCase();
    final filtered = s.data.where((p) => p.nombre.toLowerCase().contains(query)).toList();
    return filtered.isEmpty ? const RemoteEmpty() : RemoteSuccess(filtered);
  }

  String _formatoAntiguedad(DateTime fecha) {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1) return 'hace instantes';
    if (diff.inHours < 1) return 'hace ${diff.inMinutes} min';
    return 'hace ${diff.inHours} h';
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppConstants.accentBlue.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        if (_ultimaActualizacionLocal != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Sin conexión — datos de ${_formatoAntiguedad(_ultimaActualizacionLocal!)}',
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        Expanded(
          child: ProductsListSection(
            state: _filteredState,
            onRetry: _loadProducts,
            onProductTap: (product) {
              context.push('/products/${product.idProducto}').then((_) => _loadProducts());
            },
          ),
        ),
      ],
    );
  }
}