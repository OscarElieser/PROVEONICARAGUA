// ==============================================================================
// PROVEO NICARAGUA - Sistema de Diseño: Tipografía (lib/core/theme/app_typography.dart)
// ¿Qué hace?: Define los estilos tipográficos, tamaños de fuente, grosores e interlineados oficiales.
// ¿Por qué se utiliza?: Otorga una jerarquía visual clara, legible y profesional en pantallas móviles y de escritorio.
// ==============================================================================

// Importa los componentes de estilos de texto de Flutter Material
import 'package:flutter/material.dart';

/// Escala tipográfica estandarizada para toda la aplicación PROVEO.
///
/// Centraliza los estilos de texto para que los ajustes de legibilidad se reflejen automáticamente.
class AppTypography {
  // --------------------------------------------------------------------------
  // ENCABEZADOS PRINCIPALES Y HERO TITLES (Títulos de portadas y landings)
  // --------------------------------------------------------------------------

  /// Título colosal para el hero principal de la pantalla de bienvenida / landing.
  static const displayLarge = TextStyle(
    fontSize: 40,
    height: 1.08,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
  );

  /// Título de sección destacada en dashboards y módulos de impacto.
  static const displayMedium = TextStyle(
    fontSize: 32,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
  );

  // --------------------------------------------------------------------------
  // TÍTULOS DE PANTALLA Y CATEGORÍAS (Headlines de vistas intermedias)
  // --------------------------------------------------------------------------

  /// Título principal de vistas de navegación (ej: "Directorio de Proveedores").
  static const headlineLarge = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
  );

  /// Subtítulo de bloques grandes o tarjetas modulares.
  static const headlineMedium = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
  );

  // --------------------------------------------------------------------------
  // TÍTULOS DE TARJETAS Y DIÁLOGOS (Titles)
  // --------------------------------------------------------------------------

  /// Título de producto individual o nombre de empresa en listas.
  static const titleLarge = TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Título de especificación técnica o campos de formulario.
  static const titleMedium = TextStyle(
    fontSize: 15,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // --------------------------------------------------------------------------
  // CUERPO DE TEXTO Y DESCRIPCIONES (Body text)
  // --------------------------------------------------------------------------

  /// Párrafos explicativos, descripciones de productos y artículos.
  static const bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Texto estándar para reseñas, especificaciones y tablas.
  static const bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Texto pequeño para pies de foto, fechas, notas legales y avisos menores.
  static const bodySmall = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // --------------------------------------------------------------------------
  // ETIQUETAS Y BOTONES (Labels)
  // --------------------------------------------------------------------------

  /// Texto en negrita para botones de acción (ElevatedButton, OutlinedButton) y badges.
  static const labelLarge = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
}