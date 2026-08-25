// ==============================================================================
// PROVEO NICARAGUA - Panel de Control del Emprendedor (lib/screens/entrepreneur_dashboard_screen.dart)
// ¿Qué hace?: Sirve como panel administrativo para los compradores y emprendedores registrados en la plataforma.
// ¿Por qué se utiliza?: Centraliza el seguimiento de pedidos, solicitudes de cotización activas y proveedores favoritos.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

/// Panel de control operativo exclusivo para compradores y emprendedores.
class EntrepreneurDashboardScreen extends StatelessWidget {
  /// Constructor constante
  const EntrepreneurDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Panel del emprendedor'),
        ),
        body: const Center(
          child: Text('Bienvenido a tu panel PROVEO'),
        ),
      );
}

