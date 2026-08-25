// ==============================================================================
// PROVEO NICARAGUA - Centro de Ayuda y Preguntas Frecuentes (lib/screens/help_center_screen.dart)
// ¿Qué hace?: Presenta preguntas frecuentes expandibles (FAQ), guías sobre Match IA y acceso directo al canal de soporte.
// ¿Por qué se utiliza?: Resuelve dudas operativas comunes de emprendedores y empresas sin necesidad de abrir un ticket de soporte.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Pantalla del Centro de Ayuda con preguntas frecuentes (FAQ) y enlace a soporte directo.
class HelpCenterScreen extends StatelessWidget {
  /// Constructor constante
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Centro de Ayuda'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. SECCIÓN HERO: Encabezado degradado azul marino
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.navy, AppColors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.help_outline_rounded, color: AppColors.trustGreen, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Centro de Ayuda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Encuentra respuestas rápidas a tus preguntas',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. SECCIÓN PRINCIPAL: Acordeones de Preguntas Frecuentes
          // ------------------------------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preguntas Frecuentes',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // FAQ 1: Algoritmo Match IA
                      const _FaqTile(
                        question: '¿Qué es PROVEO Match IA?',
                        answer:
                            'Es nuestro algoritmo propietario que analiza tus requerimientos y cruza los datos con nuestro directorio de proveedores para mostrarte las mejores opciones basadas en precio, calidad, tiempo de entrega y ubicación.',
                      ),

                      // FAQ 2: Contactar Proveedor
                      const _FaqTile(
                        question: '¿Cómo contacto a un proveedor?',
                        answer:
                            'Puedes buscar proveedores y dar clic en "Ver Perfil". Ahí encontrarás la opción para enviar un mensaje directo mediante nuestro "Chat B2B" o solicitar una cotización formal.',
                      ),

                      // FAQ 3: Costos de la plataforma
                      const _FaqTile(
                        question: '¿Tiene algún costo usar la plataforma?',
                        answer:
                            'El registro y la búsqueda básica son gratuitos para los emprendedores. Existen planes premium para proveedores que desean mayor visibilidad y acceso a herramientas avanzadas.',
                      ),

                      // FAQ 4: Proceso de verificación
                      const _FaqTile(
                        question: '¿Cómo verifican a los proveedores?',
                        answer:
                            'Nuestro equipo realiza una validación exhaustiva de documentos legales, registros comerciales y referencias en Nicaragua para asegurar que los proveedores cuenten con la insignia "Verificado".',
                      ),
                      const SizedBox(height: 48),

                      // Tarjeta de Asistencia y Soporte Directo 24/7
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.paleBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.support_agent_rounded, color: AppColors.blue, size: 32),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿Necesitas más ayuda?',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Nuestro equipo de soporte está disponible 24/7.',
                                    style: TextStyle(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pushNamed(context, '/contact'),
                              style: FilledButton.styleFrom(backgroundColor: AppColors.trustGreen),
                              child: const Text('Contáctanos'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 3. PIE DE PÁGINA UNIVERSAL
          // ------------------------------------------------------------------
          const SliverToBoxAdapter(child: PremiumFooter()),
        ],
      ),
    );
  }
}

/// Acordeón desplegable (ExpansionTile) para desplegar cada pregunta y respuesta frecuente.
class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

