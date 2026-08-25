// ==============================================================================
// PROVEO NICARAGUA - Componente Gráfico del Logotipo Oficial (lib/core/widgets/proveo_logo.dart)
// ¿Qué hace?: Renderiza el isotipo/logotipo oficial de Proveo con soporte de accesibilidad y escalabilidad.
// ¿Por qué se utiliza?: Desacopla la ruta del asset físico y asegura dimensiones uniformes en headers y footers.
// ==============================================================================

// Importa los widgets fundamentales de Flutter
import 'package:flutter/material.dart';

/// Widget reutilizable que encapsula el logotipo oficial de PROVEO Nicaragua.
class ProveoLogo extends StatelessWidget {
  /// Altura visual del logotipo en píxeles lógicos (por defecto 48px)
  final double height;

  /// Constructor constante para reutilización eficiente en memoria
  const ProveoLogo({super.key, this.height = 48});

  @override
  Widget build(BuildContext context) {
    // Semantics añade información de accesibilidad para lectores de pantalla de personas con discapacidad visual
    return Semantics(
      label: 'Logo oficial de PROVEO Nicaragua',
      image: true,
      // Renderiza la imagen desde los activos declarados en pubspec.yaml
      child: Image.asset(
        'assets/logo/proveo_logo.png',
        height: height,
        fit: BoxFit.contain, // Mantiene la relación de aspecto original
      ),
    );
  }
}

