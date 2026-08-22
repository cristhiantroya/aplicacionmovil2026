import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';

/// COMPONENTE REUTILIZABLE 2: AsyncStateView<T>
///
/// Por qué merece abstraerse (regla de las 3 apariciones):
/// el patrón "if (isLoading) ... else if (error != null) ... else if
/// (data.isEmpty) ... else construir la lista" se repetía, casi
/// textualmente, en CUATRO pantallas del proyecto: home_screen (lista
/// de productos), conversations_screen (lista de conversaciones),
/// points_screen (lista/mapa de puntos seguros) y product_detail_screen
/// (carga del producto). Cada copia tenía spinners, textos de error y
/// botones de "Reintentar" ligeramente distintos entre sí. Este
/// componente resuelve EXPLÍCITAMENTE los 3 estados (cargando, vacío,
/// error) en un solo lugar, y delega el contenido real mediante un
/// builder, sin conocer nada del backend ni de la navegación.
class AsyncStateView<T> extends StatelessWidget {
  /// DATOS DE ENTRADA
  final bool isLoading;
  final String? errorMessage;
  final List<T> data;

  /// CALLBACKS
  final VoidCallback? onRetry;

  /// CONTENIDO DELEGADO (slot pattern): este widget no sabe cómo se ve
  /// una fila de producto, de conversación o de punto seguro — solo
  /// orquesta el estado y delega la construcción real al llamador.
  final Widget Function(BuildContext context, List<T> data) contentBuilder;

  /// CONFIGURACIÓN DE PRESENTACIÓN (personalizable, con valores por
  /// defecto razonables si no se especifican)
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget? loadingWidget;

  const AsyncStateView({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.data,
    required this.contentBuilder,
    this.onRetry,
    this.emptyMessage = 'No hay datos disponibles',
    this.emptyIcon = Icons.inbox_outlined,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppSemanticColors>()!;

    // ESTADO: CARGANDO
    if (isLoading) {
      return Center(
        child:
            loadingWidget ??
            const CircularProgressIndicator(
              semanticsLabel: 'Cargando contenido',
            ),
      );
    }

    // ESTADO: ERROR
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPrimitives.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: tokens.danger),
              const SizedBox(height: AppPrimitives.space3),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: tokens.textPrimary),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppPrimitives.space4),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // ESTADO: VACÍO
    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPrimitives.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(emptyIcon, size: 48, color: tokens.textSecondary),
              const SizedBox(height: AppPrimitives.space3),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: tokens.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // ESTADO: CON CONTENIDO — delega al builder del llamador
    return contentBuilder(context, data);
  }
}
