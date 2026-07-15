import 'product_model.dart';
import 'user_model.dart';
import 'mensaje_model.dart';

class Conversacion {
  final int idConversacion;
  final int idProducto;
  final Product producto;
  final User otherParticipant;
  final Mensaje? ultimoMensaje;
  final bool tieneNoLeidos;

  Conversacion({
    required this.idConversacion,
    required this.idProducto,
    required this.producto,
    required this.otherParticipant,
    this.ultimoMensaje,
    required this.tieneNoLeidos,
  });

  factory Conversacion.fromJson(Map<String, dynamic> json) {
    return Conversacion(
      idConversacion: json['id_conversacion'],
      idProducto: json['id_producto'],
      producto: Product.fromJson(json['producto']),
      otherParticipant: User.fromJson(json['otherParticipant']),
      ultimoMensaje: json['ultimo_mensaje'] != null
          ? Mensaje.fromJson(json['ultimo_mensaje'])
          : null,
      tieneNoLeidos: json['tiene_no_leidos'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_conversacion': idConversacion,
      'id_producto': idProducto,
      'producto': producto.toJson(),
      'otherParticipant': otherParticipant.toJson(),
      'ultimo_mensaje': ultimoMensaje?.toJson(),
      'tiene_no_leidos': tieneNoLeidos,
    };
  }
}
