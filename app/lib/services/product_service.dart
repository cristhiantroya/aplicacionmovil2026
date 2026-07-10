import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService);

  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _apiService.dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getUserProducts() async {
    try {
      final response = await _apiService.dio.get('/products/user');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProduct({
    required String nombre,
    String? descripcion,
    required double precio,
    required String estadoUso,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/products',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': precio,
          'estado_uso': estadoUso,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
