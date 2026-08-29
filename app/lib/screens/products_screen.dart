import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../widgets/products_list_section_assembled.dart';
import '../state/remote_state.dart';

/// Pantalla de listado de productos (antes era parte de HomeScreen;
/// ahora es la pantalla raíz de la pestaña /home dentro del shell).
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  RemoteState<List<Product>> _state = const RemoteLoading();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _state = const RemoteLoading();
    });
    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);
      final products = await productService.getProducts();
      setState(() {
        _state = products.isEmpty ? const RemoteEmpty() : RemoteSuccess(products);
      });
    } catch (e) {
      setState(() {
        _state = RemoteFailure(e.toString());
      });
    }
  }

  RemoteState<List<Product>> get _filteredState {
    final s = _state;
    if (s is! RemoteSuccess<List<Product>>) return s;
    if (_searchQuery.trim().isEmpty) return s;
    final query = _searchQuery.trim().toLowerCase();
    final filtered = s.data.where((p) => p.nombre.toLowerCase().contains(query)).toList();
    return filtered.isEmpty ? const RemoteEmpty() : RemoteSuccess(filtered);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppConstants.accentBlue.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ProductsListSection(
            state: _filteredState,
            onRetry: _loadProducts,
            onProductTap: (product) {
              // Parámetro pasado POR LA RUTA (id en la URL), no como
              // objeto Product completo transportado entre pantallas.
              context.push('/products/${product.idProducto}').then((_) => _loadProducts());
            },
          ),
        ),
      ],
    );
  }
}