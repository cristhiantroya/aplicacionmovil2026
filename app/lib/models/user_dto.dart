import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: 'id_usuario')
  final int idUsuario;

  final String nombre;

  final String correo;

  final String? telefono;

  final double reputacion;

  @JsonKey(name: 'estado_cuenta')
  final String estadoCuenta;

  const UserDto({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    this.telefono,
    required this.reputacion,
    required this.estadoCuenta,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserDtoToJson(this);
}