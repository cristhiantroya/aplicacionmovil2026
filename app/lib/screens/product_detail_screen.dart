import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';
import '../services/transaction_service.dart';
import '../models/product_model.dart';
import '../models/point_model.dart';
import 'points_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  String? _errorMessage;
  SafePoint? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);
      _product = await productService.getProductById(widget.productId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _startTransaction() async {
    if (_selectedPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un punto seguro')),
      );
      return;
    }

    try {
      final apiService = ApiService();
      final transactionService = TransactionService(apiService);
      await transactionService.createTransaction(
        idProducto: widget.productId,
        idPunto: _selectedPoint!.idPunto,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transacción iniciada exitosamente')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del producto')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del producto')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProduct,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_product!.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product images
            if (_product!.imagenes.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _product!.imagenes.length,
                  itemBuilder: (context, index) {
                    final image = _product!.imagenes[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image.url,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.8,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, size: 80),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product!.nombre,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_product!.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        color: AppConstants.surfaceLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _product!.estadoUso == 'nuevo'
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _product!.estadoUso == 'nuevo' ? 'Nuevo' : 'Usado',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.accentBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _product!.estadoDisponibilidad == 'disponible'
                                ? 'Disponible'
                                : _product!.estadoDisponibilidad == 'reservado'
                                ? 'Reservado'
                                : 'Vendido',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_product!.categoria != null && _product!.categoria!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.category, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Categoría: ${_product!.categoria!.replaceAll('_', ' ').replaceFirstMapped(RegExp(r'^\w'), (match) => match.group(0)!.toUpperCase())}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    if (_product!.ubicacion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Ubicación: ${_product!.ubicacion}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (_product!.descripcion != null)
                      Text(
                        _product!.descripcion!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    if (_product!.usuario != null)
                      Text(
                        'Vendedor: ${_product!.usuario!.nombre}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_product!.estadoDisponibilidad == 'disponible') ...[
              const Text(
                'Selecciona un punto seguro para la entrega',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const PointsScreen(isSelecting: true),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _selectedPoint = result as SafePoint;
                    });
                  }
                },
                icon: const Icon(Icons.location_on),
                label: Text(
                  _selectedPoint != null
                      ? _selectedPoint!.nombre
                      : 'Seleccionar punto seguro',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.surfaceLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Iniciar Transacción',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
