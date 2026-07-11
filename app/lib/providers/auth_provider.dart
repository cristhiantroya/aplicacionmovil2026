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
    final accessToken = await _authService.getAccessToken();

    if (user != null && accessToken != null) {
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
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];
      final userJson = response['user'];
      final user = User.fromJson(userJson);

      await _authService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
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
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];
      final userJson = response['user'];
      final user = User.fromJson(userJson);

      await _authService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
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
    final refreshToken = await _authService.getRefreshToken();
    await _authService.logout(refreshToken: refreshToken);
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
