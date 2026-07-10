import '../models/transaction_model.dart';
import 'api_service.dart';

class TransactionService {
  final ApiService _apiService;

  TransactionService(this._apiService);

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _apiService.dio.get('/transactions');
      final List<dynamic> data = response.data;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createTransaction({
    required int idProducto,
    required int idPunto,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/transactions',
        data: {
          'id_producto': idProducto,
          'id_punto': idPunto,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateTransactionStatus({
    required int id,
    required String estadoEscrow,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '/transactions/$id',
        data: {
          'estado_escrow': estadoEscrow,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
