// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Proveedores Favoritos (lib/screens/favorites_screen.dart)
// ¿Qué hace?: Lista las empresas y fabricantes guardados por el usuario para acceso rápido recurrente.
// ¿Por qué se utiliza?: Agiliza las compras repetitivas y permite crear un directorio personalizado de confianza.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

/// Pantalla que visualiza la colección de proveedores marcados como favoritos.
class FavoritesScreen extends StatelessWidget {
  /// Constructor constante
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Favoritos'),
        ),
        body: const Center(
          child: Text('Tus proveedores guardados aparecerán aquí.'),
        ),
      );
}

