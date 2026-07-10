import '../models/verification_model.dart';
import 'api_service.dart';

class VerificationService {
  final ApiService _apiService;

  VerificationService(this._apiService);

  Future<Verification?> getVerification() async {
    try {
      final response = await _apiService.dio.get('/verifications');
      if (response.data == null) return null;
      return Verification.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> createVerification({
    required String tipoDocumento,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/verifications',
        data: {
          'tipo_documento': tipoDocumento,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
