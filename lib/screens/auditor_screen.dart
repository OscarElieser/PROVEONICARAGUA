// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Modo Auditor / Fiscalización (lib/screens/auditor_screen.dart)
// ¿Qué hace?: Presenta la interfaz de acceso para auditores externos o supervisores en modo solo lectura.
// ¿Por qué se utiliza?: Permite verificar el cumplimiento de normativas de proveedores sin otorgar permisos de edición o transacción.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

/// Pantalla restringida para usuarios con rol de auditor.
class AuditorScreen extends StatelessWidget {
  /// Constructor constante
  const AuditorScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Auditoría'),
        ),
        body: const Center(
          child: Text('Modo auditoría — Solo lectura'),
        ),
      );
}

