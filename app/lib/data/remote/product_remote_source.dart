import '../../services/api_service.dart';
import '../../models/product_dto.dart';

class ProductRemoteSource {
  final ApiService _apiService;

  ProductRemoteSource(this._apiService);

  Future<List<ProductDto>> getProducts() async {
    final response = await _apiService.dio.get(
      '/productos',
    );

    final data = response.data as List;

    return data
        .map(
          (json) => ProductDto.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}