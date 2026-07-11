import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import 'auth_service.dart';

class ApiService {
  // --- Patrón Singleton: siempre devuelve la MISMA instancia ---
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final AuthService _authService;
  bool _isRefreshing = false;
  final List<ErrorInterceptorHandler> _pendingRequests = [];

  ApiService._internal() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _authService.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _authService.getRefreshToken();
            if (refreshToken == null) {
              _logout();
              return handler.next(error);
            }

            if (_isRefreshing) {
              _pendingRequests.add(handler);
              return;
            }

            _isRefreshing = true;
            try {
              final refreshResponse = await _authService.refresh(refreshToken);
              final newAccessToken = refreshResponse['accessToken'];
              final newRefreshToken = refreshResponse['refreshToken'];
              await _authService.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );

              // Retry all pending requests
              for (final pendingHandler in _pendingRequests) {
                _retry(error.requestOptions, pendingHandler);
              }
              _pendingRequests.clear();
              // Retry the current request
              _retry(error.requestOptions, handler);
            } catch (e) {
              // Refresh failed, logout user
              _logout();
              return handler.next(error);
            } finally {
              _isRefreshing = false;
            }
          } else {
            return handler.next(error);
          }
        },
      ),
    );
  }

  void _retry(RequestOptions requestOptions, ErrorInterceptorHandler handler) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    _dio
        .request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options,
        )
        .then((response) {
          return handler.resolve(response);
        })
        .catchError((error) {
          return handler.reject(error);
        });
  }

  void Function()? onLogout;

  void _logout() {
    if (onLogout != null) {
      onLogout!();
    }
  }

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  Dio get dio => _dio;
  FlutterSecureStorage get storage => _storage;
}
