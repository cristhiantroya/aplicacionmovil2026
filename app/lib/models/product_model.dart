import 'user_model.dart';

class ProductImage {
  final int idImagen;
  final int idProducto;
  final String url;
  final DateTime creadoEn;

  ProductImage({
    required this.idImagen,
    required this.idProducto,
    required this.url,
    required this.creadoEn,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      idImagen: json['id_imagen'],
      idProducto: json['id_producto'],
      url: json['url'],
      creadoEn: DateTime.parse(json['creado_en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_imagen': idImagen,
      'id_producto': idProducto,
      'url': url,
      'creado_en': creadoEn.toIso8601String(),
    };
  }
}

class Product {
  final int idProducto;
  final int idUsuario;
  final User? usuario;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String estadoUso;
  final String estadoDisponibilidad;
  final String? categoria;
  final String? ubicacion;
  final List<ProductImage> imagenes;
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
    required this.categoria,
    this.ubicacion,
    this.imagenes = const [],
    required this.creadoEn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductImage> imagenesList = [];
    if (json['imagenes'] != null) {
      imagenesList = (json['imagenes'] as List)
          .map((i) => ProductImage.fromJson(i as Map<String, dynamic>))
          .toList();
    }

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
      categoria: json['categoria'],
      ubicacion: json['ubicacion'],
      imagenes: imagenesList,
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
      'categoria': categoria,
      'ubicacion': ubicacion,
      'imagenes': imagenes.map((i) => i.toJson()).toList(),
      'creado_en': creadoEn.toIso8601String(),
    };
  }
}
