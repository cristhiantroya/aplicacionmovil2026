import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/products_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/conversations_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/create_product_screen.dart';
import '../screens/points_screen.dart';
import '../screens/chat_screen.dart';
import '../widgets/app_shell.dart';
import '../services/api_service.dart';

/// Guarda la última ruta protegida a la que el usuario intentó entrar
/// sin estar autenticado, para poder regresarlo ahí después del login
/// ("conservar el destino pretendido").
class RouteMemory {
  static String? pendingLocation;
}

GoRouter buildAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,

    redirect: (context, state) {
      final loading = authProvider.isLoading;
      final authenticated = authProvider.isAuthenticated;
      final loc = state.matchedLocation;
      final onAuthScreen = loc == '/login' || loc == '/register';
      final onSplash = loc == '/splash';

      if (loading) {
        return onSplash ? null : '/splash';
      }

      if (!authenticated) {
        if (onAuthScreen) return null;
        RouteMemory.pendingLocation = onSplash ? null : loc;
        return '/login';
      }

      if (onAuthScreen || onSplash) {
        final target = RouteMemory.pendingLocation ?? '/home';
        RouteMemory.pendingLocation = null;
        return target;
      }

      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (context, state) => const ProductsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/conversations',
              builder: (context, state) => ConversationsScreen(apiService: ApiService()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),

      GoRoute(
        path: '/products/create',
        builder: (context, state) => const CreateProductScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/points',
        builder: (context, state) {
          final ciudad = state.uri.queryParameters['ciudad'];
          final isSelecting = state.uri.queryParameters['selecting'] == 'true';
          return PointsScreen(isSelecting: isSelecting, ciudad: ciudad);
        },
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChatScreen(idConversacion: id);
        },
      ),
    ],
  );
}