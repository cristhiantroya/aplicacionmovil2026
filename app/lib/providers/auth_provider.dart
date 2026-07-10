import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authService);

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.getUser();
    final token = await _authService.getToken();

    if (user != null && token != null) {
      _user = user;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String documentoIdentidad,
    String? telefono,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        documentoIdentidad: documentoIdentidad,
        telefono: telefono,
      );
      final token = response['token'];
      final userJson = response['user'];
      final user = User.fromJson(userJson);

      await _authService.saveToken(token);
      await _authService.saveUser(user);
      _user = user;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String correo,
    required String contrasena,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        correo: correo,
        contrasena: contrasena,
      );
      final token = response['token'];
      final userJson = response['user'];
      final user = User.fromJson(userJson);

      await _authService.saveToken(token);
      await _authService.saveUser(user);
      _user = user;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authService.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
