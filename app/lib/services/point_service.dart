import '../models/point_model.dart';
import 'api_service.dart';

class PointService {
  final ApiService _apiService;

  PointService(this._apiService);

  Future<List<SafePoint>> getSafePoints({String? ciudad}) async {
    try {
      final response = await _apiService.dio.get(
        '/points',
        queryParameters: ciudad != null ? {'ciudad': ciudad} : null,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => SafePoint.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
