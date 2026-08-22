import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';

enum AppButtonVariant { primary, danger, outlined }

/// COMPONENTE REUTILIZABLE 3: AppPrimaryButton
///
/// Por qué merece abstraerse (regla de las 3 apariciones):
/// el botón principal de acción (fondo de color, esquinas muy
/// redondeadas, ancho completo, con manejo de estado "cargando")
/// se repite en al menos 5 lugares: publicar producto, iniciar
/// transacción, guardar cambios de producto, solicitar verificación
/// y enviar mensaje de chat. Antes de abstraerlo, cada pantalla
/// implementaba su propio ElevatedButton.styleFrom con paddings y
/// colores copiados a mano (fuente del hallazgo de contraste 2.80:1
/// descrito en el informe: el color de fondo "highlightOnDark" se
/// usaba como fondo de botón con texto blanco sin verificar
/// contraste). Este componente corrige ese defecto de raíz, ya que
/// resuelve el color de texto según la variante, no por accidente.
class AppPrimaryButton extends StatelessWidget {
  /// DATOS DE ENTRADA
  final String label;

  /// CALLBACKS
  final VoidCallback? onPressed;

  /// CONFIGURACIÓN DE PRESENTACIÓN
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppSemanticColors>()!;

    late final Color background;
    late final Color foreground;
    late final BorderSide? border;

    switch (variant) {
      case AppButtonVariant.primary:
        background = tokens.primary;
        foreground = tokens.onPrimary; // contraste verificado 10.44:1
        border = null;
        break;
      case AppButtonVariant.danger:
        background = tokens.danger;
        foreground = tokens.onPrimary;
        border = null;
        break;
      case AppButtonVariant.outlined:
        background = Colors.transparent;
        foreground = tokens.danger;
        border = BorderSide(color: tokens.danger);
        break;
    }

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppPrimitives.space2),
              ],
              Text(label),
            ],
          );

    final button = ElevatedButton(
      // Deshabilitado mientras carga: evita doble envío
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        side: border,
        padding: const EdgeInsets.symmetric(vertical: AppPrimitives.space4),
        minimumSize: const Size.fromHeight(AppPrimitives.minTouchTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      child: child,
    );

    final semanticButton = Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: isLoading ? '$label, cargando' : label,
      child: button,
    );

    return fullWidth ? SizedBox(width: double.infinity, child: semanticButton) : semanticButton;
  }
}