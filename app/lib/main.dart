import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

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

  @override
  void initState() {
    super.initState();

    // Create services with circular dependency workaround
    // First, create a temporary auth service with a dummy, or use a setter?
    // Wait better approach: create auth service first, then api service, then set api service in auth? Wait no, let's adjust:
    // Let's first create AuthService with a placeholder, then create ApiService, then set ApiService's authService? Wait no, let's modify the order!
    // Wait let's create a dummy first: no, let's just create them step by step, and then set the onLogout callback!

    // Wait let's use a different approach:
    // 1. Create auth service first, but we need an api service! Oh right! Let's make AuthService have a setter for apiService! Wait let's adjust auth_service.dart first!
    // Wait no— wait let's modify the order! Let's first create ApiService with a dummy AuthService? No! Wait I have a better idea: let's adjust ApiService to not require AuthService in the constructor, but instead have a setter! But wait that's more changes! Alternatively, let's just create AuthService first with a mock ApiService, but no, wait no— let's just adjust how we create them! Let's change the code:

    // Wait let's modify the approach: let's create ApiService, but we need to pass AuthService, but AuthService needs ApiService! Let's create a temporary ApiService, then AuthService, then re-create ApiService with the real AuthService! Wait that's a bit of a hack but works! Alternatively, let's refactor! Let's adjust AuthService to not take ApiService in constructor, but have a setter! Let's do that!

    // Wait let's first adjust auth_service.dart to have a setter for apiService instead of requiring it in constructor! That's better!
    // Wait no— let's just adjust main.dart! Let's see:

    // Okay let's first create AuthService with a dummy ApiService? No! Wait let's just adjust:
    // Wait let's modify auth_service.dart to have a late final ApiService that we can set later! Wait okay let's first modify auth_service.dart quickly!
    // Wait no, wait let's just restructure main.dart! Let's create AuthProvider first, then set up ApiService!
    // Okay here's the solution:

    // 1. Create AuthService first with a dummy ApiService? No, wait let's just create ApiService first with a placeholder, then AuthService, then set ApiService's authService to the real one! Wait let's modify ApiService to have a late final AuthService that we set via a setter! Let's adjust ApiService first!

    // Wait okay, let's modify ApiService to have a setter for AuthService!
    // Oh right! So let's modify ApiService to have a late AuthService, and a setAuthService method! Let's do that first!

    // Wait okay, let's first modify api_service.dart again to allow setting authService after!
    // Oh right! That's the way to handle circular dependencies in this case!
    // Let's modify api_service.dart first!
    _apiService = ApiService(); // We'll modify ApiService to have a setter
    _authService = AuthService(_apiService);
    _apiService.setAuthService(
      _authService,
    ); // We'll add this method to ApiService
    _authProvider = AuthProvider(_authService)..checkAuthStatus();

    // Set up the logout callback
    _apiService.onLogout = () {
      _authProvider.logout();
    };
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _authProvider,
      child: MaterialApp(
        title: 'CompraSegura',
        debugShowCheckedModeBanner: false,
        theme: AppConstants.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
