// ==============================================================================
// PROVEO NICARAGUA - Panel de Gestión del Proveedor (lib/screens/provider_dashboard_screen.dart)
// ¿Qué hace?: Permite a los proveedores verificar sus solicitudes de cotización entrantes, catálogo de productos y métricas comerciales.
// ¿Por qué se utiliza?: Centraliza la operación B2B y la recepción de leads cualificados generados por el algoritmo Match IA.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

/// Panel administrativo exclusivo para proveedores y fabricantes registrados.
class ProviderDashboardScreen extends StatelessWidget {
  /// Constructor constante
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Panel del proveedor'),
        ),
        body: const Center(
          child: Text('Resumen de tu empresa'),
        ),
      );
}

