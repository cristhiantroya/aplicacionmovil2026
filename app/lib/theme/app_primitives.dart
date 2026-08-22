import 'package:flutter/material.dart';

/// TOKENS PRIMITIVOS
/// Valores crudos, sin significado de uso asignado todavía.
/// Ningún widget de la app debe referenciar estos directamente
/// (excepto el archivo de tema, que los traduce a tokens semánticos).
class AppPrimitives {
  AppPrimitives._();

  // Color
  static const Color navy900 = Color(0xFF00002A);
  static const Color blue700 = Color(0xFF1A3F75);
  static const Color blue500 = Color(0xFF4E6A9C);
  static const Color blue300 = Color(0xFF4EA4CC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green500 = Color(0xFF4CAF50);
  static const Color orange500 = Color(0xFFFF9800);
  static const Color red500 = Color(0xFFE53935);
  static const Color grey400 = Color(0xFFBDBDBD);

  // Espaciado (escala de 4px)
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space6 = 24;
  static const double space8 = 32;

  // Radio de bordes
  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusPill = 999;

  // Tipografía
  static const String fontFamily = 'Roboto';
  static const double fontSizeCaption = 12;
  static const double fontSizeBody = 14;
  static const double fontSizeBodyLarge = 16;
  static const double fontSizeH2 = 20;
  static const double fontSizeH1 = 24;
  static const double fontSizeDisplay = 28;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightBold = FontWeight.w700;

  // Tamaño mínimo de área táctil (WCAG 2.5.5 / Material)
  static const double minTouchTarget = 48;
}