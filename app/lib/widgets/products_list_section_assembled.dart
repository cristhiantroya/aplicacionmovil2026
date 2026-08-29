import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';
import '../state/remote_state.dart';
import 'app_status_badge.dart';
import 'async_state_view.dart';
import 'app_primary_button.dart';
import '../models/product_model.dart';

/// PANTALLA ENSAMBLADA: sección de listado de productos de HomeScreen,
/// reconstruida usando EXCLUSIVAMENTE los 3 componentes del catálogo.
/// Ahora recibe un RemoteState<List<Product>> (tipo cerrado) en vez de
/// isLoading/errorMessage/products sueltos, conectando el modelo de
/// estado de la Semana 11 con el catálogo de componentes de la
/// Semana 10.
///
/// Nótese que este widget no conoce el backend (no importa dio ni
/// ApiService) ni la ruta de navegación a la que ir al tocar un
/// producto: recibe `onProductTap` como callback, y quien lo instancie
/// decide a dónde navegar.
class ProductsListSection extends StatelessWidget {
  final RemoteState<List<Product>> state;
  final VoidCallback onRetry;
  final void Function(Product product) onProductTap;

  const ProductsListSection({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppSemanticColors>()!;

    return AsyncStateView<Product>(
      state: state,
      onRetry: onRetry,
      emptyMessage: 'No hay productos disponibles todavía',
      emptyIcon: Icons.shopping_bag_outlined,
      contentBuilder: (context, items) {
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            final hasImage =
                product.imagenes.isNotEmpty &&
                product.imagenes.first.url != null;

            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sectionGap / 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
                leading: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: Image.network(
                          product.imagenes.first.url!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: tokens.surfaceVariant,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.card,
                                  ),
                                ),
                                child: const Icon(Icons.image, size: 28),
                              ),
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: tokens.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                        child: const Icon(Icons.image, size: 28),
                      ),
                title: Text(
                  product.nombre,
                  style: AppTypography.h2.copyWith(color: tokens.textPrimary),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.itemGap),
                  child: Row(
                    children: [
                      Text(
                        '\$${product.precio.toStringAsFixed(2)}',
                        style: AppTypography.body.copyWith(
                          color: tokens.highlightOnDark,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.itemGap),
                      AppStatusBadge(
                        label: product.estadoUso == 'nuevo' ? 'Nuevo' : 'Usado',
                        variant: product.estadoUso == 'nuevo'
                            ? AppStatusVariant.success
                            : AppStatusVariant.warning,
                        compact: true,
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => onProductTap(product),
              ),
            );
          },
        );
      },
    );
  }
}

class EmptyProductsActions extends StatelessWidget {
  final VoidCallback onCreateProduct;

  const EmptyProductsActions({super.key, required this.onCreateProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: AppPrimaryButton(
        label: 'Publicar tu primer producto',
        icon: Icons.add,
        onPressed: onCreateProduct,
      ),
    );
  }
}
