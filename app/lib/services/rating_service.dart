import '../models/rating_model.dart';
import 'api_service.dart';

class RatingService {
  final ApiService _apiService;

  RatingService(this._apiService);

  Future<List<Rating>> getUserRatings() async {
    try {
      final response = await _apiService.dio.get('/ratings/user');
      final List<dynamic> data = response.data;
      return data.map((json) => Rating.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createRating({
    required int idTransaccion,
    required int puntuacion,
    String? comentario,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/ratings',
        data: {
          'id_transaccion': idTransaccion,
          'puntuacion': puntuacion,
          'comentario': comentario,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
