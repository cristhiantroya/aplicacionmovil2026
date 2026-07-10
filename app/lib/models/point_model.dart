class SafePoint {
  final int idPunto;
  final String nombre;
  final String direccion;
  final String ciudad;
  final double latitud;
  final double longitud;

  SafePoint({
    required this.idPunto,
    required this.nombre,
    required this.direccion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
  });

  factory SafePoint.fromJson(Map<String, dynamic> json) {
    return SafePoint(
      idPunto: json['id_punto'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_punto': idPunto,
      'nombre': nombre,
      'direccion': direccion,
      'ciudad': ciudad,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}
