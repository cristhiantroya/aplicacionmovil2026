// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImageDto _$ProductImageDtoFromJson(Map<String, dynamic> json) =>
    ProductImageDto(
      idImagen: (json['id_imagen'] as num).toInt(),
      idProducto: (json['id_producto'] as num).toInt(),
      url: json['url'] as String?,
      estado: json['estado'] as String,
      creadoEn: DateTime.parse(json['creado_en'] as String),
    );

Map<String, dynamic> _$ProductImageDtoToJson(ProductImageDto instance) =>
    <String, dynamic>{
      'id_imagen': instance.idImagen,
      'id_producto': instance.idProducto,
      'url': instance.url,
      'estado': instance.estado,
      'creado_en': instance.creadoEn.toIso8601String(),
    };

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  idProducto: (json['id_producto'] as num).toInt(),
  idUsuario: (json['id_usuario'] as num).toInt(),
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String?,
  precio: json['precio'],
  estadoUso: json['estado_uso'] as String,
  estadoDisponibilidad: json['estado_disponibilidad'] as String,
  categoria: json['categoria'] as String?,
  ubicacion: json['ubicacion'] as String?,
  imagenes:
      (json['imagenes'] as List<dynamic>?)
          ?.map((e) => ProductImageDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  creadoEn: DateTime.parse(json['creado_en'] as String),
);

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id_producto': instance.idProducto,
      'id_usuario': instance.idUsuario,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'precio': instance.precio,
      'estado_uso': instance.estadoUso,
      'estado_disponibilidad': instance.estadoDisponibilidad,
      'categoria': instance.categoria,
      'ubicacion': instance.ubicacion,
      'imagenes': instance.imagenes,
      'creado_en': instance.creadoEn.toIso8601String(),
    };
