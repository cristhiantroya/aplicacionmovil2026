class NotificationModel {
  final int idNotificacion;
  final int idUsuario;
  final String titulo;
  final String mensaje;
  final String tipo;
  final bool leido;
  final DateTime fechaEnvio;

  NotificationModel({
    required this.idNotificacion,
    required this.idUsuario,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.leido,
    required this.fechaEnvio,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      idNotificacion: json['id_notificacion'],
      idUsuario: json['id_usuario'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      tipo: json['tipo'],
      leido: json['leido'],
      fechaEnvio: DateTime.parse(json['fecha_envio']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_notificacion': idNotificacion,
      'id_usuario': idUsuario,
      'titulo': titulo,
      'mensaje': mensaje,
      'tipo': tipo,
      'leido': leido,
      'fecha_envio': fechaEnvio.toIso8601String(),
    };
  }
}
