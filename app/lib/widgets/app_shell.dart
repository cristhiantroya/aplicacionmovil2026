import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';

/// Envoltorio de la navegación inferior. Cada pestaña es una RAMA
/// independiente del StatefulShellRoute (ver app_router.dart) — esta
/// es la "ruta anidada" que exige el taller: /home, /transactions,
/// /conversations, /notifications y /profile viven todas dentro de
/// este shell común.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompraSegura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Ruta protegida fuera del shell, empujada sobre la pila.
              context.push('/products/create');
            },
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transacciones'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Conversaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: navigationShell.currentIndex,
        // goBranch conserva el estado de cada pestaña (por ejemplo, el
        // texto ya escrito en el buscador de productos) al volver a
        // ella, en vez de reconstruirla desde cero.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstants.primaryDark,
        selectedItemColor: AppConstants.surfaceLight,
        unselectedItemColor: AppConstants.grey,
      ),
    );
  }
}