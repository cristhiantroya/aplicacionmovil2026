import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'constants/app_constants.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ApiService _apiService;
  late AuthService _authService;
  late AuthProvider _authProvider;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    // Mismo workaround de dependencia circular que ya teníamos: se
    // conserva sin cambios.
    _apiService = ApiService();
    _authService = AuthService(_apiService);
    _apiService.setAuthService(_authService);
    _authProvider = AuthProvider(_authService)..checkAuthStatus();

    _apiService.onLogout = () {
      _authProvider.logout();
    };

    // El router se construye UNA sola vez, con una referencia directa
    // al AuthProvider: su `redirect` lee el estado de autenticación
    // en cada evaluación, y se re-evalúa automáticamente gracias a
    // `refreshListenable: authProvider` (ver router/app_router.dart).
    _router = buildAppRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authProvider,
      child: MaterialApp.router(
        title: 'CompraSegura',
        debugShowCheckedModeBanner: false,
        theme: AppConstants.darkTheme,
        routerConfig: _router,
      ),
    );
  }
}