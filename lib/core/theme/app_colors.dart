// ==============================================================================
// PROVEO NICARAGUA - Sistema de Diseño: Paleta de Colores (lib/core/theme/app_colors.dart)
// ¿Qué hace?: Centraliza la definición de tokens de color corporativos, fondos, estados y tipografías.
// ¿Por qué se utiliza?: Garantiza consistencia visual absoluta y facilita cambios de branding en toda la app.
// ==============================================================================

// Importa los tipos gráficos fundamentales de Flutter (Color)
import 'package:flutter/material.dart';

/// Paleta oficial de colores de PROVEO basada en la identidad de marca B2B.
class AppColors {
  // --------------------------------------------------------------------------
  // COLORES PRIMARIOS Y CORPORATIVOS (Identidad de marca Proveo)
  // --------------------------------------------------------------------------

  /// Azul Oscuro oficial PROVEO: Color principal para headers, botones de acción primaria y títulos de alto impacto.
  static const navy = Color(0xFF032040);

  /// Variante de azul profundo para estados hover, gradientes y tarjetas de destaque.
  static const darkBlue = Color(0xFF003060);

  /// Azul Medio oficial PROVEO: Utilizado en elementos interactivos secundarios, tabs activas e iconos.
  static const blue = Color(0xFF004177);

  /// Verde Azulado / Teal oficial: Acentúa badges de IA, recomendaciones inteligentes y tags informativos.
  static const teal = Color(0xFF0D6C80);

  /// Verde Lima oficial PROVEO: Color de confianza para botones de confirmación, WhatsApp y validaciones.
  static const trustGreen = Color(0xFF6EA01B);

  /// Alias de verde éxito para indicar estados aprobados, entregas a tiempo y cotizaciones aceptadas.
  static const successGreen = Color(0xFF6EA01B);

  // --------------------------------------------------------------------------
  // COLORES DE SUPERFICIE, FONDOS Y BORDES (Diseño limpio y moderno)
  // --------------------------------------------------------------------------

  /// Blanco puro estándar para tarjetas elevadas, modales y campos de texto.
  static const white = Color(0xFFFFFFFF);

  /// Gris azulado ultra claro para el fondo global del Scaffold, descansando la vista del usuario.
  static const background = Color(0xFFF7F9FC);

  /// Superficie de tarjetas y paneles contenedores de información.
  static const surface = Color(0xFFFFFFFF);

  /// Color de borde sutil para delimitar inputs, divisores y tarjetas sin sobrecargar la interfaz.
  static const border = Color(0xFFE4E8EF);

  // --------------------------------------------------------------------------
  // COLORES DE TEXTO (Jerarquía y contraste accesible)
  // --------------------------------------------------------------------------

  /// Color de texto primario con alto contraste para encabezados, precios y nombres de productos.
  static const textPrimary = Color(0xFF032040);

  /// Color de texto secundario para subtítulos, etiquetas descriptivas y placeholders.
  static const textSecondary = Color(0xFF667085);

  // --------------------------------------------------------------------------
  // COLORES DE ESTADO Y FEEDBACK (Notificaciones y alertas del sistema)
  // --------------------------------------------------------------------------

  /// Amarillo ámbar para advertencias, estados pendientes y calificaciones intermedias.
  static const warning = Color(0xFFF4B740);

  /// Rojo de alerta para mensajes de error de autenticación, cancelaciones o campos inválidos.
  static const error = Color(0xFFD64545);

  /// Azul informativo para tooltips, avisos del sistema y consejos de negociación.
  static const info = Color(0xFF0D6C80);

  // --------------------------------------------------------------------------
  // FONDOS TENUES Y CONTENEDORES CON TINTE (Microinteracciones y chips)
  // --------------------------------------------------------------------------

  /// Azul pastel sutil para fondos de iconos primarios y áreas seleccionadas.
  static const paleBlue = Color(0xFFEAF2F9);

  /// Verde pastel sutil para fondos de insignias de verificación y éxito.
  static const paleGreen = Color(0xFFEFF8E4);
}

