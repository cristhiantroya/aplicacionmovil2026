import 'package:flutter/material.dart';
import 'app_primitives.dart';
export 'app_primitives.dart';

/// TOKENS SEMÁNTICOS
/// Asignan un SIGNIFICADO DE USO a los primitivos (ej. "primary",
/// "success"), en vez de un valor crudo. Los componentes consumen
/// SOLO estos tokens semánticos, nunca AppPrimitives directamente,
/// para que un cambio de marca no requiera tocar cada componente.
///
/// Se implementa como ThemeExtension para que los widgets lo lean
/// desde el propio Theme (Theme.of(context).extension<AppSemanticColors>()),
/// cumpliendo con "consumir los tokens desde el tema".
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color onPrimary;
  final Color accent;

  /// highlightOnDark: reservado para texto/iconos claros SOBRE FONDOS
  /// OSCUROS (contraste verificado 7.26:1). NO usar como fondo de
  /// botón con texto blanco: como fondo, su contraste con texto
  /// blanco es de solo 2.80:1 y no cumple WCAG AA (hallazgo real,
  /// ver informe de accesibilidad).
  final Color highlightOnDark;

  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color danger;

  const AppSemanticColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.highlightOnDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.danger,
  });

  static const AppSemanticColors standard = AppSemanticColors(
    background: AppPrimitives.navy900,
    surface: AppPrimitives.blue700,
    surfaceVariant: AppPrimitives.blue500,
    primary: AppPrimitives.blue700,
    onPrimary: AppPrimitives.white,
    accent: AppPrimitives.blue500,
    highlightOnDark: AppPrimitives.blue300,
    textPrimary: AppPrimitives.white,
    textSecondary: Color(0xB3FFFFFF), // white 70%
    success: AppPrimitives.green500,
    warning: AppPrimitives.orange500,
    danger: AppPrimitives.red500,
  );

  @override
  AppSemanticColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? highlightOnDark,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppSemanticColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      highlightOnDark: highlightOnDark ?? this.highlightOnDark,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      highlightOnDark: Color.lerp(highlightOnDark, other.highlightOnDark, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

/// Tokens semánticos de espaciado y radio (no requieren ThemeExtension,
/// se referencian como constantes estáticas desde los componentes).
class AppSpacing {
  AppSpacing._();
  static const double screenPadding = AppPrimitives.space4;
  static const double cardPadding = AppPrimitives.space4;
  static const double itemGap = AppPrimitives.space2;
  static const double sectionGap = AppPrimitives.space6;
}

class AppRadius {
  AppRadius._();
  static const double card = AppPrimitives.radiusMd;
  static const double button = AppPrimitives.radiusLg;
  static const double input = AppPrimitives.radiusLg;
  static const double badge = AppPrimitives.radiusPill;
}

class AppTypography {
  AppTypography._();
  static const TextStyle h1 = TextStyle(
    fontSize: AppPrimitives.fontSizeH1,
    fontWeight: AppPrimitives.weightBold,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: AppPrimitives.fontSizeH2,
    fontWeight: AppPrimitives.weightBold,
  );
  static const TextStyle body = TextStyle(
    fontSize: AppPrimitives.fontSizeBodyLarge,
    fontWeight: AppPrimitives.weightRegular,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: AppPrimitives.fontSizeBody,
    fontWeight: AppPrimitives.weightRegular,
  );
  static const TextStyle caption = TextStyle(
    fontSize: AppPrimitives.fontSizeCaption,
    fontWeight: AppPrimitives.weightMedium,
  );
}