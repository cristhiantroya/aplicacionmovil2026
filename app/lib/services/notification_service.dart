import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiService.dio.get('/notifications');
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> markAsRead(int id) async {
    try {
      final response = await _apiService.dio.put('/notifications/$id/read');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
