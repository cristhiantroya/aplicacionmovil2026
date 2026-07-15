import '../models/conversacion_model.dart';
import '../models/mensaje_model.dart';
import 'api_service.dart';

class ChatService {
  final ApiService _apiService;

  ChatService(this._apiService);

  Future<Conversacion> createOrGetConversation(int idProducto) async {
    final response = await _apiService.dio.post(
      '/chat/conversaciones',
      data: {'id_producto': idProducto},
    );
    return Conversacion.fromJson(response.data);
  }

  Future<List<Conversacion>> getConversations() async {
    final response = await _apiService.dio.get('/chat/conversaciones');
    final List<dynamic> data = response.data;
    return data.map((json) => Conversacion.fromJson(json)).toList();
  }

  Future<List<Mensaje>> getConversationMessages(int idConversacion) async {
    final response = await _apiService.dio.get(
      '/chat/conversaciones/$idConversacion/mensajes',
    );
    final List<dynamic> data = response.data;
    return data.map((json) => Mensaje.fromJson(json)).toList();
  }

  Future<Mensaje> sendMessage(int idConversacion, String contenido) async {
    final response = await _apiService.dio.post(
      '/chat/conversaciones/$idConversacion/mensajes',
      data: {'contenido': contenido},
    );
    return Mensaje.fromJson(response.data);
  }

  Future<void> markConversationAsRead(int idConversacion) async {
    await _apiService.dio.patch('/chat/conversaciones/$idConversacion/leido');
  }
}
