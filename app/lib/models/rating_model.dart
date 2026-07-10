import 'transaction_model.dart';
import 'user_model.dart';

class Rating {
  final int idCalificacion;
  final int idTransaccion;
  final Transaction? transaccion;
  final int idEmisor;
  final User? emisor;
  final int idReceptor;
  final User? receptor;
  final int puntuacion;
  final String? comentario;
  final DateTime fechaCalificacion;

  Rating({
    required this.idCalificacion,
    required this.idTransaccion,
    this.transaccion,
    required this.idEmisor,
    this.emisor,
    required this.idReceptor,
    this.receptor,
    required this.puntuacion,
    this.comentario,
    required this.fechaCalificacion,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      idCalificacion: json['id_calificacion'],
      idTransaccion: json['id_transaccion'],
      transaccion: json['transaccion'] != null
          ? Transaction.fromJson(json['transaccion'])
          : null,
      idEmisor: json['id_emisor'],
      emisor: json['emisor'] != null ? User.fromJson(json['emisor']) : null,
      idReceptor: json['id_receptor'],
      receptor: json['receptor'] != null
          ? User.fromJson(json['receptor'])
          : null,
      puntuacion: json['puntuacion'],
      comentario: json['comentario'],
      fechaCalificacion: DateTime.parse(json['fecha_calificacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_calificacion': idCalificacion,
      'id_transaccion': idTransaccion,
      'transaccion': transaccion?.toJson(),
      'id_emisor': idEmisor,
      'emisor': emisor?.toJson(),
      'id_receptor': idReceptor,
      'receptor': receptor?.toJson(),
      'puntuacion': puntuacion,
      'comentario': comentario,
      'fecha_calificacion': fechaCalificacion.toIso8601String(),
    };
  }
}
