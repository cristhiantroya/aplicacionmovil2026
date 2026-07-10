import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final apiService = ApiService();
      final notificationService = NotificationService(apiService);
      _notifications = await notificationService.getNotifications();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      final apiService = ApiService();
      final notificationService = NotificationService(apiService);
      await notificationService.markAsRead(id);
      await _loadNotifications();
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : _notifications.isEmpty
          ? const Center(child: Text('No tienes notificaciones'))
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: notification.leido
                        ? null
                        : AppConstants.accentBlue.withValues(alpha: 0.3),
                    child: ListTile(
                      title: Text(
                        notification.titulo,
                        style: TextStyle(
                          fontWeight: notification.leido
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification.mensaje),
                      trailing: notification.leido
                          ? null
                          : const Icon(
                              Icons.circle,
                              color: AppConstants.surfaceLight,
                              size: 12,
                            ),
                      onTap: () {
                        if (!notification.leido) {
                          _markAsRead(notification.idNotificacion);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
