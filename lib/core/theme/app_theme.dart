// ==============================================================================
// PROVEO NICARAGUA - Sistema de Diseño: Tema Global Material 3 (lib/core/theme/app_theme.dart)
// ¿Qué hace?: Configura y consolida la apariencia visual, esquemas de color y comportamientos de widgets en Flutter.
// ¿Por qué se utiliza?: Centraliza el diseño responsivo, la consistencia de bordes redondeados y la estética de Proveo.
// ==============================================================================

// Importa los componentes de diseño de Flutter Material
import 'package:flutter/material.dart';

// Importa la paleta de colores corporativos
import 'app_colors.dart';

// Importa la escala tipográfica estandarizada
import 'app_typography.dart';

/// Clase que define el tema visual global (ThemeData) utilizado en toda la plataforma PROVEO.
class AppTheme {
  /// Genera y retorna el [ThemeData] para el modo claro de la aplicación.
  static ThemeData get light {
    // Genera un esquema de color coherente a partir de nuestro color semilla corporativo (Navy)
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.navy,         // Color principal de botones e interacciones
      secondary: AppColors.trustGreen, // Color de acento para confianza y éxito
      surface: AppColors.surface,       // Fondo de tarjetas y hojas modales
      error: AppColors.error,           // Color de alertas y validaciones
    );

    return ThemeData(
      // Habilita el sistema de diseño Material Design 3 más moderno de Flutter
      useMaterial3: true,

      // Inyecta el esquema de color personalizado
      colorScheme: scheme,

      // Establece el color de fondo por defecto para todas las pantallas Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // Define la fuente predeterminada Inter para mantener legibilidad moderna
      fontFamily: 'Inter',

      // Mapea la escala tipográfica personalizada aplicando los colores de texto corporativos
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),

      // Configuración homogénea de la barra superior (AppBar)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background, // Mismo tono del Scaffold para efecto limpio (flat)
        foregroundColor: AppColors.textPrimary, // Color de iconos y títulos en el AppBar
        elevation: 0,                           // Sin sombra brusca debajo de la barra
        centerTitle: false,                     // Título alineado a la izquierda según estética moderna
      ),

      // Estilo predeterminado de todas las tarjetas (Cards) de proveedores y productos
      cardTheme: CardThemeData(
        color: AppColors.surface,                                            // Fondo blanco
        elevation: 0,                                                        // Sin elevación Material clásica
        margin: EdgeInsets.zero,                                             // Sin margen automático invasivo
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Bordes redondeados suaves
      ),

      // Configuración de campos de texto (TextFormField y TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,                                        // Fondo blanco para destacar del gris de fondo
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),                          // Curvatura amigable en esquinas
          borderSide: const BorderSide(color: AppColors.border),             // Borde sutil neutro
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),             // Borde cuando el campo no tiene foco
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),  // Resaltado en azul marino al escribir
        ),
      ),

      // Estilo de los botones principales (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,                                   // Fondo azul marino
          foregroundColor: Colors.white,                                     // Texto en blanco con alto contraste
          minimumSize: const Size(0, 50),                                    // Altura táctil cómoda (50px)
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),           // Tipografía en negrita
        ),
      ),
    );
  }
}

