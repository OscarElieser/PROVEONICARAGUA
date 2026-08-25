// ==============================================================================
// PROVEO NICARAGUA - Términos y Condiciones de Uso (lib/screens/terms_conditions_screen.dart)
// ¿Qué hace?: Describe los derechos, obligaciones, alcance de intermediación y normas legales que rigen el uso de la plataforma.
// ¿Por qué se utiliza?: Establece el marco jurídico formal entre PROVEO y las empresas o emprendedores que interactúan en la red.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Pantalla legal que expone los Términos y Condiciones generales de servicio en PROVEO Nicaragua.
class TermsConditionsScreen extends StatelessWidget {
  /// Constructor constante
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Términos y Condiciones'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. HERO BANNER: Encabezado institucional con icono de mazo legal y fecha
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
                    Icon(Icons.gavel_rounded, color: AppColors.trustGreen, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Términos y Condiciones',
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
                      'Última actualización: 20 de Agosto, 2026',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. SECCIÓN PRINCIPAL: Cláusulas Contractuales y Normas de Uso
          // ------------------------------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cláusula 1: Aceptación
                      _SectionTitle(title: '1. Aceptación de los Términos'),
                      _SectionText(
                        text:
                            'Al acceder y utilizar PROVEO Nicaragua, usted acepta estar sujeto a estos Términos y Condiciones y a nuestra Política de Privacidad. Si no está de acuerdo con alguna parte de los términos, no podrá acceder al servicio.',
                      ),

                      // Cláusula 2: Descripción del Servicio
                      _SectionTitle(title: '2. Descripción del Servicio'),
                      _SectionText(
                        text:
                            'PROVEO es una plataforma B2B que conecta a empresas y emprendedores en Nicaragua con proveedores verificados, facilitando el proceso de cotización y negociación a través de herramientas de Inteligencia Artificial.',
                      ),

                      // Cláusula 3: Normas de Uso Ético
                      _SectionTitle(title: '3. Uso de la Plataforma'),
                      _SectionText(
                        text:
                            'Usted se compromete a utilizar la plataforma de manera ética y legal. Está estrictamente prohibido proporcionar información falsa, intentar vulnerar la seguridad del sitio o utilizar la plataforma para actividades ilícitas.',
                      ),

                      // Cláusula 4: Cuentas y Seguridad de Acceso
                      _SectionTitle(title: '4. Cuentas y Seguridad'),
                      _SectionText(
                        text:
                            'Usted es responsable de salvaguardar la contraseña que utiliza para acceder al servicio y de cualquier actividad o acción bajo su contraseña. Debe notificarnos inmediatamente si detecta alguna violación de seguridad o uso no autorizado de su cuenta.',
                      ),

                      // Cláusula 5: Alcance de Verificación y Responsabilidad
                      _SectionTitle(title: '5. Verificación de Proveedores'),
                      _SectionText(
                        text:
                            'Aunque nos esforzamos por verificar a todos los proveedores, PROVEO no garantiza la ejecución final de los contratos entre las partes. La plataforma actúa como un puente de conexión comercial.',
                      ),

                      // Cláusula 6: Modificaciones del Acuerdo
                      _SectionTitle(title: '6. Modificaciones'),
                      _SectionText(
                        text:
                            'Nos reservamos el derecho, a nuestra sola discreción, de modificar o reemplazar estos Términos en cualquier momento. Revisaremos la fecha de "Última actualización" en la parte superior de esta página.',
                      ),
                      SizedBox(height: 48),
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

/// Título de sección para cada acápite de los términos contractuales.
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Párrafo de texto formal con formato tipográfico estilizado.
class _SectionText extends StatelessWidget {
  final String text;
  const _SectionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.6,
      ),
    );
  }
}

