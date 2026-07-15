class Mensaje {
  final int idMensaje;
  final int idConversacion;
  final int idEmisor;
  final String contenido;
  final bool leido;
  final DateTime creadoEn;

  Mensaje({
    required this.idMensaje,
    required this.idConversacion,
    required this.idEmisor,
    required this.contenido,
    required this.leido,
    required this.creadoEn,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idMensaje: json['id_mensaje'],
      idConversacion: json['id_conversacion'],
      idEmisor: json['id_emisor'],
      contenido: json['contenido'],
      leido: json['leido'] ?? false,
      creadoEn: DateTime.parse(json['creado_en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_mensaje': idMensaje,
      'id_conversacion': idConversacion,
      'id_emisor': idEmisor,
      'contenido': contenido,
      'leido': leido,
      'creado_en': creadoEn.toIso8601String(),
    };
  }
}
