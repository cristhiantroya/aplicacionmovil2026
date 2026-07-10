class Verification {
  final int idVerificacion;
  final int idUsuario;
  final String tipoDocumento;
  final String estado;
  final DateTime fechaSolicitud;

  Verification({
    required this.idVerificacion,
    required this.idUsuario,
    required this.tipoDocumento,
    required this.estado,
    required this.fechaSolicitud,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      idVerificacion: json['id_verificacion'],
      idUsuario: json['id_usuario'],
      tipoDocumento: json['tipo_documento'],
      estado: json['estado'],
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_verificacion': idVerificacion,
      'id_usuario': idUsuario,
      'tipo_documento': tipoDocumento,
      'estado': estado,
      'fecha_solicitud': fechaSolicitud.toIso8601String(),
    };
  }
}
