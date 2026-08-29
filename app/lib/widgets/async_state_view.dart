import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';
import '../state/remote_state.dart';

/// COMPONENTE REUTILIZABLE 2: AsyncStateView<T>
///
/// Ahora recibe un ÚNICO parámetro `state` de tipo RemoteState<List<T>>
/// (un tipo cerrado con casos mutuamente excluyentes), en vez de tres
/// banderas sueltas (isLoading/errorMessage/data). Esto elimina por
/// construcción los estados imposibles: ya no puede "estar cargando y
/// mostrar datos a la vez" porque el propio tipo lo impide, no porque
/// el desarrollador recuerde validarlo en cada pantalla.
class AsyncStateView<T> extends StatelessWidget {
  /// DATOS DE ENTRADA
  final RemoteState<List<T>> state;

  /// CALLBACKS
  final VoidCallback? onRetry;

  /// CONTENIDO DELEGADO (slot pattern)
  final Widget Function(BuildContext context, List<T> data) contentBuilder;

  /// CONFIGURACIÓN DE PRESENTACIÓN
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget? loadingWidget;

  const AsyncStateView({
    super.key,
    required this.state,
    required this.contentBuilder,
    this.onRetry,
    this.emptyMessage = 'No hay datos disponibles',
    this.emptyIcon = Icons.inbox_outlined,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppSemanticColors>()!;

    // El `switch` exhaustivo es posible gracias a que RemoteState es
    // `sealed`: el compilador exige cubrir todos los casos.
    return switch (state) {
      RemoteIdle() || RemoteLoading() => Center(
        child:
            loadingWidget ??
            const CircularProgressIndicator(
              semanticsLabel: 'Cargando contenido',
            ),
      ),
      RemoteFailure(:final message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPrimitives.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: tokens.danger),
              const SizedBox(height: AppPrimitives.space3),
              Text(
                message,
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
      ),
      RemoteEmpty() => Center(
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
      ),
      RemoteSuccess(:final data) => contentBuilder(context, data),
    };
  }
}
