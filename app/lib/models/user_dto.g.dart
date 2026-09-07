// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  idUsuario: (json['id_usuario'] as num).toInt(),
  nombre: json['nombre'] as String,
  correo: json['correo'] as String,
  telefono: json['telefono'] as String?,
  reputacion: (json['reputacion'] as num).toDouble(),
  estadoCuenta: json['estado_cuenta'] as String,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id_usuario': instance.idUsuario,
  'nombre': instance.nombre,
  'correo': instance.correo,
  'telefono': instance.telefono,
  'reputacion': instance.reputacion,
  'estado_cuenta': instance.estadoCuenta,
};
