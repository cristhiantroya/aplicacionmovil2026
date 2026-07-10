import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/transaction_service.dart';
import '../models/transaction_model.dart';
import 'rating_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final apiService = ApiService();
      final transactionService = TransactionService(apiService);
      _transactions = await transactionService.getTransactions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(Transaction transaction, String newStatus) async {
    try {
      final apiService = ApiService();
      final transactionService = TransactionService(apiService);
      await transactionService.updateTransactionStatus(
        id: transaction.idTransaccion,
        estadoEscrow: newStatus,
      );
      await _loadTransactions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estado actualizado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return Colors.orange;
      case 'en_garantia':
        return Colors.blue;
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'disputada':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(String status) {
    switch (status) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_garantia':
        return 'En Garantía';
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      case 'disputada':
        return 'Disputada';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
      ),
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
                        onPressed: _loadTransactions,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _transactions.isEmpty
                  ? const Center(
                      child: Text('No tienes transacciones'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTransactions,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        transaction.producto?.nombre ??
                                            'Producto',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                              transaction.estadoEscrow),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          _getLocalizedStatus(
                                              transaction.estadoEscrow),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${transaction.monto.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: AppConstants.surfaceLight,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (transaction.puntoSeguro != null)
                                    Text(
                                      'Punto seguro: ${transaction.puntoSeguro!.nombre}',
                                    ),
                                  const SizedBox(height: 16),
                                  if (transaction.estadoEscrow == 'pendiente')
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => _updateStatus(
                                                transaction, 'en_garantia'),
                                            child: const Text('Pagar y poner en garantía'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (transaction.estadoEscrow == 'en_garantia')
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => _updateStatus(
                                                transaction, 'completada'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            child: const Text(
                                                'Confirmar recepción'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (transaction.estadoEscrow == 'completada')
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RatingScreen(
                                                    transactionId: transaction
                                                        .idTransaccion,
                                                  ),
                                                ),
                                              ).then(
                                                  (_) => _loadTransactions());
                                            },
                                            child: const Text('Calificar'),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
