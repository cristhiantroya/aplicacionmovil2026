import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductImageDto {
  @JsonKey(name: 'id_imagen')
  final int idImagen;

  @JsonKey(name: 'id_producto')
  final int idProducto;

  final String? url;

  final String estado;

  @JsonKey(name: 'creado_en')
  final DateTime creadoEn;

  const ProductImageDto({
    required this.idImagen,
    required this.idProducto,
    this.url,
    required this.estado,
    required this.creadoEn,
  });

  factory ProductImageDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProductImageDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductImageDtoToJson(this);
}

@JsonSerializable()
class ProductDto {
  @JsonKey(name: 'id_producto')
  final int idProducto;

  @JsonKey(name: 'id_usuario')
  final int idUsuario;

  final String nombre;

  final String? descripcion;

  final dynamic precio;

  @JsonKey(name: 'estado_uso')
  final String estadoUso;

  @JsonKey(name: 'estado_disponibilidad')
  final String estadoDisponibilidad;

  final String? categoria;

  final String? ubicacion;

  final List<ProductImageDto> imagenes;

  @JsonKey(name: 'creado_en')
  final DateTime creadoEn;

  const ProductDto({
    required this.idProducto,
    required this.idUsuario,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.estadoUso,
    required this.estadoDisponibilidad,
    this.categoria,
    this.ubicacion,
    this.imagenes = const [],
    required this.creadoEn,
  });

  factory ProductDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductDtoToJson(this);
}