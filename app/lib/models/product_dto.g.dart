// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
      'creado_en': instance.creadoEn.toIso8601String(),
    };
