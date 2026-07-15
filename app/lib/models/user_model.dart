class User {
  final int idUsuario;
  final String nombre;
  final String correo;
  final String? telefono;
  final double reputacion;
  final String estadoCuenta;

  User({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    this.telefono,
    required this.reputacion,
    required this.estadoCuenta,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json['id_usuario'],
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'],
      reputacion: json['reputacion'] != null
          ? (json['reputacion'] as num).toDouble()
          : 0.0,
      estadoCuenta: json['estado_cuenta'] ?? 'activo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
      'reputacion': reputacion,
      'estado_cuenta': estadoCuenta,
    };
  }
}
