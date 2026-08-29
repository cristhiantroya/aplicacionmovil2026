import 'package:flutter/material.dart';

/// Se muestra mientras AuthProvider verifica si ya existe una sesión
/// guardada (checkAuthStatus). El router usa este estado para no
/// redirigir prematuramente a /login antes de tener la respuesta.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}