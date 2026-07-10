import 'user_model.dart';
import 'product_model.dart';
import 'point_model.dart';

class Transaction {
  final int idTransaccion;
  final int idComprador;
  final User? comprador;
  final int idVendedor;
  final User? vendedor;
  final int idProducto;
  final Product? producto;
  final int idPunto;
  final SafePoint? puntoSeguro;
  final double monto;
  final String estadoEscrow;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  Transaction({
    required this.idTransaccion,
    required this.idComprador,
    this.comprador,
    required this.idVendedor,
    this.vendedor,
    required this.idProducto,
    this.producto,
    required this.idPunto,
    this.puntoSeguro,
    required this.monto,
    required this.estadoEscrow,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      idTransaccion: json['id_transaccion'],
      idComprador: json['id_comprador'],
      comprador: json['comprador'] != null
          ? User.fromJson(json['comprador'])
          : null,
      idVendedor: json['id_vendedor'],
      vendedor: json['vendedor'] != null
          ? User.fromJson(json['vendedor'])
          : null,
      idProducto: json['id_producto'],
      producto: json['producto'] != null
          ? Product.fromJson(json['producto'])
          : null,
      idPunto: json['id_punto'],
      puntoSeguro: json['puntoSeguro'] != null
          ? SafePoint.fromJson(json['puntoSeguro'])
          : null,
      monto: (json['monto'] as num).toDouble(),
      estadoEscrow: json['estado_escrow'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaccion': idTransaccion,
      'id_comprador': idComprador,
      'comprador': comprador?.toJson(),
      'id_vendedor': idVendedor,
      'vendedor': vendedor?.toJson(),
      'id_producto': idProducto,
      'producto': producto?.toJson(),
      'id_punto': idPunto,
      'puntoSeguro': puntoSeguro?.toJson(),
      'monto': monto,
      'estado_escrow': estadoEscrow,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }
}
