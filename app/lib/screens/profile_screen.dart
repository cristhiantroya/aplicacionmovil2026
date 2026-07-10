import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/verification_service.dart';
import '../services/rating_service.dart';
import '../models/rating_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isVerified = false;
  bool _hasRequestedVerification = false;
  bool _loadingVerification = true;
  List<Rating> _ratings = [];
  bool _loadingRatings = true;
  final _documentTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVerification();
    _loadRatings();
  }

  Future<void> _loadVerification() async {
    try {
      final apiService = ApiService();
      final verificationService = VerificationService(apiService);
      final verification = await verificationService.getVerification();
      setState(() {
        _isVerified = verification?.estado == 'aprobado';
        _hasRequestedVerification = verification != null;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _loadingVerification = false;
      });
    }
  }

  Future<void> _loadRatings() async {
    try {
      final apiService = ApiService();
      final ratingService = RatingService(apiService);
      _ratings = await ratingService.getUserRatings();
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _loadingRatings = false;
      });
    }
  }

  Future<void> _requestVerification() async {
    if (_documentTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese el tipo de documento')),
      );
      return;
    }

    try {
      final apiService = ApiService();
      final verificationService = VerificationService(apiService);
      await verificationService.createVerification(
        tipoDocumento: _documentTypeController.text,
      );
      await _loadVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud de verificación enviada exitosamente'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppConstants.primaryBlue,
                      child: Text(
                        (user?.nombre.substring(0, 1).toUpperCase()) ?? 'U',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.nombre ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(user?.correo ?? ''),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${user?.reputacion.toStringAsFixed(1) ?? '0.0'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _loadingVerification
                        ? const CircularProgressIndicator()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isVerified
                                  ? Colors.green
                                  : _hasRequestedVerification
                                  ? Colors.orange
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _isVerified
                                  ? 'Verificado'
                                  : _hasRequestedVerification
                                  ? 'Verificación pendiente'
                                  : 'No verificado',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!_isVerified && !_hasRequestedVerification) ...[
              const Text(
                'Solicitar Verificación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentTypeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de documento (DNI, Pasaporte, etc.)',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requestVerification,
                child: const Text('Enviar Solicitud'),
              ),
            ],
            const SizedBox(height: 32),
            const Text(
              'Mis Calificaciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _loadingRatings
                ? const Center(child: CircularProgressIndicator())
                : _ratings.isEmpty
                ? const Center(child: Text('No tienes calificaciones aún'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _ratings.length,
                    itemBuilder: (context, index) {
                      final rating = _ratings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < rating.puntuacion
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(rating.emisor?.nombre ?? 'Usuario'),
                            ],
                          ),
                          subtitle: rating.comentario != null
                              ? Text(rating.comentario!)
                              : null,
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
