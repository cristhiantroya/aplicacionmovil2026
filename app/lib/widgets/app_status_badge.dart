import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';

/// Variante semántica del badge. El color NUNCA es el único canal
/// de información: cada variante trae también un ícono por defecto,
/// para no depender exclusivamente del color (requisito de accesibilidad).
enum AppStatusVariant { success, warning, danger, info }

/// COMPONENTE REUTILIZABLE 1: AppStatusBadge
///
/// Por qué merece abstraerse (regla de las 3 apariciones):
/// aparece, con la MISMA estructura visual (texto + fondo redondeado
/// de color), en al menos 4 lugares del proyecto: el estado "Nuevo/Usado"
/// de un producto (home_screen y product_detail_screen), el estado
/// "Disponible/Reservado/Vendido" (product_detail_screen), la categoría
/// del producto (product_detail_screen), y el indicador de verificación
/// del usuario ("Verificado"/"Pendiente"/"No verificado" en profile_screen).
/// Antes de abstraerlo, cada pantalla reconstruía el mismo Container +
/// BoxDecoration + Text a mano, con colores condicionales repetidos.
class AppStatusBadge extends StatelessWidget {
  /// DATOS DE ENTRADA
  final String label;

  /// CONFIGURACIÓN DE PRESENTACIÓN
  final AppStatusVariant variant;
  final IconData? icon;
  final bool compact;

  /// CALLBACKS (opcional: permite usarlo como filtro tocable sin que
  /// el propio badge conozca qué acción disparar)
  final VoidCallback? onTap;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
    this.compact = false,
    this.onTap,
  });

  Color _backgroundColor(AppSemanticColors tokens) {
    switch (variant) {
      case AppStatusVariant.success:
        return tokens.success;
      case AppStatusVariant.warning:
        return tokens.warning;
      case AppStatusVariant.danger:
        return tokens.danger;
      case AppStatusVariant.info:
        return tokens.accent;
    }
  }

  IconData _defaultIcon() {
    switch (variant) {
      case AppStatusVariant.success:
        return Icons.check_circle;
      case AppStatusVariant.warning:
        return Icons.schedule;
      case AppStatusVariant.danger:
        return Icons.cancel;
      case AppStatusVariant.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppSemanticColors>()!;
    final bg = _backgroundColor(tokens);
    final iconGap = compact ? AppPrimitives.space1 : AppPrimitives.space2;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon ?? _defaultIcon(), size: compact ? 14 : 16, color: tokens.onPrimary),
        SizedBox(width: iconGap),
        Text(
          label,
          style: (compact ? AppTypography.caption : AppTypography.bodySmall).copyWith(
            color: tokens.onPrimary,
            fontWeight: AppPrimitives.weightMedium,
          ),
        ),
      ],
    );

    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.itemGap : AppSpacing.itemGap * 1.5,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.badge)),
      // Área táctil mínima cuando es interactivo (WCAG 2.5.5)
      constraints: onTap != null ? const BoxConstraints(minHeight: 32) : null,
      child: content,
    );

    if (onTap == null) return Semantics(label: label, child: badge);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.badge),
        child: badge,
      ),
    );
  }
}