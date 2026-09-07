abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No se pudo establecer conexión con el servidor.',
  ]);
}

class AuthException extends AppException {
  const AuthException([
    super.message = 'Tu sesión ha expirado. Inicia sesión nuevamente.',
  ]);
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException({
    required this.fieldErrors,
    String message = 'Datos inválidos.',
  }) : super(message);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Ocurrió un error interno en el servidor.',
  ]);
}