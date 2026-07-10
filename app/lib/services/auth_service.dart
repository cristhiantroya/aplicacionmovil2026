import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String documentoIdentidad,
    String? telefono,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/register',
        data: {
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
          'documento_identidad': documentoIdentidad,
          'telefono': telefono,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {
          'correo': correo,
          'contrasena': contrasena,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveToken(String token) async {
    await _apiService.storage.write(key: 'auth_token', value: token);
  }

  Future<void> saveUser(User user) async {
    await _apiService.storage.write(key: 'user', value: userToJson(user));
  }

  Future<String?> getToken() async {
    return await _apiService.storage.read(key: 'auth_token');
  }

  Future<User?> getUser() async {
    final userJson = await _apiService.storage.read(key: 'user');
    if (userJson != null) {
      return userFromJson(userJson);
    }
    return null;
  }

  Future<void> logout() async {
    await _apiService.storage.delete(key: 'auth_token');
    await _apiService.storage.delete(key: 'user');
  }

  String userToJson(User user) {
    return '${user.idUsuario}|${user.nombre}|${user.correo}|${user.telefono ?? ''}|${user.reputacion}|${user.estadoCuenta}';
  }

  User userFromJson(String json) {
    final parts = json.split('|');
    return User(
      idUsuario: int.parse(parts[0]),
      nombre: parts[1],
      correo: parts[2],
      telefono: parts[3].isEmpty ? null : parts[3],
      reputacion: double.parse(parts[4]),
      estadoCuenta: parts[5],
    );
  }
}
