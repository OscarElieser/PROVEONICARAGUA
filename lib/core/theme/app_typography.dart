// ==============================================================================
// PROVEO NICARAGUA - Sistema de Diseño: Tipografía Oficial (lib/core/theme/app_typography.dart)
// ¿Qué hace?: Define los estilos tipográficos, tamaños de fuente, grosores e interlineados oficiales.
// ¿Por qué se utiliza?: Otorga una jerarquía visual clara, legible y profesional basada en Montserrat.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Escala tipográfica oficial de PROVEO basada en Montserrat.
///
/// Especificaciones de diseño:
/// - 01 — TÍTULO:    Montserrat SemiBold — 36 pt (FontWeight.w600)
/// - 02 — SUBTÍTULO: Montserrat Medium   — 20 pt (FontWeight.w500)
/// - 03 — CUERPO:    Montserrat Regular  — 12 pt (FontWeight.w400)
class AppTypography {
  static const String fontFamily = 'Montserrat';

  // ---------------------------------------------------------------------------
  // TOKENS DIRECTOS DE LA GUÍA DE MARCA OFICIAL PROVEO
  // ---------------------------------------------------------------------------

  /// 01 — TÍTULO: Montserrat SemiBold — 36 pt
  static TextStyle get titulo => GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.5,
      );

  /// 02 — SUBTÍTULO: Montserrat Medium — 20 pt
  static TextStyle get subtitulo => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: -0.2,
      );

  /// 03 — CUERPO: Montserrat Regular — 12 pt
  static TextStyle get cuerpo => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0,
      );

  // ---------------------------------------------------------------------------
  // ESCALA TIPOGRÁFICA MATERIAL 3 (MONTSERRAT)
  // ---------------------------------------------------------------------------

  /// Título colosal para banners de impacto extremo
  static TextStyle get displayLarge => GoogleFonts.montserrat(
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  /// Corresponde a 01 — TÍTULO: Montserrat SemiBold — 36 pt
  static TextStyle get displayMedium => GoogleFonts.montserrat(
        fontSize: 36,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.montserrat(
        fontSize: 30,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.montserrat(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.montserrat(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  static TextStyle get headlineSmall => GoogleFonts.montserrat(
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  /// Corresponde a 02 — SUBTÍTULO: Montserrat Medium — 20 pt
  static TextStyle get titleLarge => GoogleFonts.montserrat(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.montserrat(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  static TextStyle get titleSmall => GoogleFonts.montserrat(
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  /// Corresponde a 03 — CUERPO: Montserrat Regular — 12 pt
  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get bodySmall => GoogleFonts.montserrat(
        fontSize: 11,
        height: 1.35,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );

  static TextStyle get labelLarge => GoogleFonts.montserrat(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  static TextStyle get labelMedium => GoogleFonts.montserrat(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );

  static TextStyle get labelSmall => GoogleFonts.montserrat(
        fontSize: 10,
        height: 1.2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );
}

/// Extensión de conveniencia para acceder a la escala tipográfica oficial de PROVEO directamente desde BuildContext.
extension AppTypographyExtension on BuildContext {
  /// 01 — TÍTULO: Montserrat SemiBold — 36 pt
  TextStyle get titulo => AppTypography.titulo;

  /// 02 — SUBTÍTULO: Montserrat Medium — 20 pt
  TextStyle get subtitulo => AppTypography.subtitulo;

  /// 03 — CUERPO: Montserrat Regular — 12 pt
  TextStyle get cuerpo => AppTypography.cuerpo;
}