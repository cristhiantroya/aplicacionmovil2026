import 'user_model.dart';

class Product {
  final int idProducto;
  final int idUsuario;
  final User? usuario;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String estadoUso;
  final String estadoDisponibilidad;
  final DateTime creadoEn;

  Product({
    required this.idProducto,
    required this.idUsuario,
    this.usuario,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.estadoUso,
    required this.estadoDisponibilidad,
    required this.creadoEn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProducto: json['id_producto'],
      idUsuario: json['id_usuario'],
      usuario: json['usuario'] != null ? User.fromJson(json['usuario']) : null,
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      // Prisma serializa los campos Decimal como texto (ej. "25.00"),
      // así que aceptamos tanto String como num al convertirlo.
      precio: json['precio'] is String
          ? double.parse(json['precio'])
          : (json['precio'] as num).toDouble(),
      estadoUso: json['estado_uso'],
      estadoDisponibilidad: json['estado_disponibilidad'],
      creadoEn: DateTime.parse(json['creado_en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_usuario': idUsuario,
      'usuario': usuario?.toJson(),
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'estado_uso': estadoUso,
      'estado_disponibilidad': estadoDisponibilidad,
      'creado_en': creadoEn.toIso8601String(),
    };
  }
}
