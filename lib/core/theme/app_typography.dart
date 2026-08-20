import 'package:flutter/material.dart';

/// Escala tipografica compartida por las superficies de PROVEO.
/// Mantenerla en un unico lugar permite ajustar la personalidad visual
/// sin recorrer todas las pantallas.
class AppTypography {
  static const displayLarge = TextStyle(fontSize: 40, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: 0);
  static const displayMedium = TextStyle(fontSize: 32, height: 1.1, fontWeight: FontWeight.w800, letterSpacing: 0);
  static const headlineLarge = TextStyle(fontSize: 28, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: 0);
  static const headlineMedium = TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w800, letterSpacing: 0);
  static const titleLarge = TextStyle(fontSize: 18, height: 1.25, fontWeight: FontWeight.w700, letterSpacing: 0);
  static const titleMedium = TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w700, letterSpacing: 0);
  static const bodyLarge = TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w400, letterSpacing: 0);
  static const bodyMedium = TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w400, letterSpacing: 0);
  static const bodySmall = TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w400, letterSpacing: 0);
  static const labelLarge = TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w700, letterSpacing: 0);
}