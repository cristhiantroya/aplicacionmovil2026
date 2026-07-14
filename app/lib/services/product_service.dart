import 'dart:io';
import '../models/product_model.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';

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
    required String categoria,
    String? ubicacion,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/products',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': precio,
          'estado_uso': estadoUso,
          'categoria': categoria,
          'ubicacion': ubicacion,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadProductImage({
    required int productId,
    required File imageFile,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      final response = await _apiService.dio.post(
        '/products/$productId/images',
        data: formData,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProductImage({
    required int productId,
    required int imageId,
  }) async {
    try {
      await _apiService.dio.delete('/products/$productId/images/$imageId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.dio.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }
}
