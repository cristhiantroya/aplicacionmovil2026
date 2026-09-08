import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../widgets/products_list_section_assembled.dart';
import '../state/remote_state.dart';
import '../db/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/repositories/product_repository.dart';
import '../data/remote/product_remote_source.dart';
import '../data/local/product_local_source.dart';

/// Pantalla de listado de productos (antes era parte de HomeScreen;
/// ahora es la pantalla raíz de la pestaña /home dentro del shell).
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  final AppDatabase _db = AppDatabase();

  late final ProductRepository _repository;

  RemoteState<List<Product>> _state = const RemoteLoading();

  DateTime? _ultimaActualizacionLocal;

  String _searchQuery = '';

  final TextEditingController _searchController =
      TextEditingController();

  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _repository = ProductRepository(
      ProductRemoteSource(ApiService()),
      ProductLocalSource(_db),
    );

    _loadProducts();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _state = const RemoteLoading();
    });

    try {
      final products = await _repository.getProducts();

      setState(() {
        _ultimaActualizacionLocal = null;

        _state = products.isEmpty
            ? const RemoteEmpty()
            : RemoteSuccess(products);
      });
    } catch (e) {
      setState(() {
        _state = RemoteFailure(e.toString());
      });
    }
  }

  RemoteState<List<Product>> get _filteredState {
    final s = _state;

    if (s is! RemoteSuccess<List<Product>>) {
      return s;
    }

    if (_searchQuery.trim().isEmpty) {
      return s;
    }

    final query =
        _searchQuery.trim().toLowerCase();

    final filtered = s.data
        .where(
          (p) =>
              p.nombre.toLowerCase().contains(query),
        )
        .toList();

    return filtered.isEmpty
        ? const RemoteEmpty()
        : RemoteSuccess(filtered);
  }

  String _formatoAntiguedad(DateTime fecha) {
    final diff =
        DateTime.now().difference(fecha);

    if (diff.inMinutes < 1) {
      return 'hace instantes';
    }

    if (diff.inHours < 1) {
      return 'hace ${diff.inMinutes} min';
    }

    return 'hace ${diff.inHours} h';
  }

  Widget _buildSearchBar() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchController,
        style:
            const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white54,
          ),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
          filled: true,
          fillColor:
              AppConstants.accentBlue.withValues(
            alpha: 0.3,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),
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
        if (_ultimaActualizacionLocal != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Text(
              'Sin conexión — datos de ${_formatoAntiguedad(_ultimaActualizacionLocal!)}',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        Expanded(
          child: ProductsListSection(
            state: _filteredState,
            onRetry: _loadProducts,
            onProductTap: (product) {
              context
                  .push(
                    '/products/${product.idProducto}',
                  )
                  .then(
                    (_) => _loadProducts(),
                  );
            },
          ),
        ),
      ],
    );
  }
}