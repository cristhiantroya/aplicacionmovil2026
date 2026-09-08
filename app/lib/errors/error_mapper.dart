import 'package:dio/dio.dart';

import 'app_exception.dart';

class ErrorMapper {
  static AppException fromDio(
    DioException exception,
  ) {
    if (exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const NetworkException();
    }

    final statusCode =
        exception.response?.statusCode;

    if (statusCode == 401 ||
        statusCode == 403) {
      return const AuthException();
    }

    if (statusCode == 400 ||
        statusCode == 422) {
      return const ValidationException(
        fieldErrors: {},
      );
    }

    if (statusCode != null &&
        statusCode >= 500) {
      return const ServerException();
    }

    return const ServerException(
      'Ocurrió un error inesperado.',
    );
  }
}