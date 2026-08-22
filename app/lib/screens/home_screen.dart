import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../widgets/products_list_section_assembled.dart';
import 'product_detail_screen.dart';
import 'create_product_screen.dart';
import 'transactions_screen.dart';
import 'conversations_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedIndex = 0;
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
      _isLoading = true;
    });
    try {
      final apiService = ApiService();
      final productService = ProductService(apiService);
      _products = await productService.getProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.trim().isEmpty) {
      return _products;
    }
    final query = _searchQuery.trim().toLowerCase();
    return _products
        .where((p) => p.nombre.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildProductsScreen(),
      const TransactionsScreen(),
      ConversationsScreen(apiService: ApiService()),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CompraSegura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const CreateProductScreen(),
                    ),
                  )
                  .then((_) => _loadProducts());
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Conversaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstants.primaryDark,
        selectedItemColor: AppConstants.surfaceLight,
        unselectedItemColor: AppConstants.grey,
      ),
    );
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

  Widget _buildProductsScreen() {
    return Column(
      children: [
        _buildSearchBar(),
        // Pantalla ensamblada EXCLUSIVAMENTE con componentes del catálogo:
        // ProductsListSection internamente usa AsyncStateView (resuelve
        // cargando/vacío/error) y AppStatusBadge (estado del producto).
        Expanded(
          child: ProductsListSection(
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            products: _filteredProducts,
            onRetry: _loadProducts,
            onProductTap: (product) {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(productId: product.idProducto),
                    ),
                  )
                  .then((_) => _loadProducts());
            },
          ),
        ),
      ],
    );
  }
}