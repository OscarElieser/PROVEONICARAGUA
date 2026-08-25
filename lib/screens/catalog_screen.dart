// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Catálogo Digital de Productos (lib/screens/catalog_screen.dart)
// ¿Qué hace?: Muestra el catálogo interactivo de artículos y fichas técnicas del proveedor seleccionado.
// ¿Por qué se utiliza?: Permite a los compradores explorar productos detallados antes de solicitar una cotización formal.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

/// Pantalla informativa para visualizar el catálogo digital de un proveedor.
class CatalogScreen extends StatelessWidget {
  /// Constructor constante
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo digital'),
        ),
        body: const Center(
          child: Text('El proveedor aún no ha publicado su catálogo.'),
        ),
      );
}