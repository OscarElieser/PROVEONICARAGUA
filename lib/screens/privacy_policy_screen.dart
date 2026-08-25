// ==============================================================================
// PROVEO NICARAGUA - Política de Privacidad y Tratamiento de Datos (lib/screens/privacy_policy_screen.dart)
// ¿Qué hace?: Detalla las cláusulas de recopilación, almacenamiento, encriptación y derechos de privacidad de datos de las empresas.
// ¿Por qué se utiliza?: Garantiza el cumplimiento normativo y transparencia sobre el tratamiento de la información en PROVEO.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Pantalla informativa con el documento legal de Política de Privacidad de PROVEO.
class PrivacyPolicyScreen extends StatelessWidget {
  /// Constructor constante
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Política de Privacidad'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. HERO BANNER: Encabezado institucional con icono de escudo y fecha
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.teal, AppColors.navy],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.shield_rounded, color: Colors.white, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Política de Privacidad',
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
          // 2. SECCIÓN PRINCIPAL: Cláusulas y Artículos Legales
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
                      // Cláusula 1: Recopilación
                      _SectionTitle(title: '1. Recopilación de Información'),
                      _SectionText(
                        text:
                            'En PROVEO recopilamos información personal que usted nos proporciona directamente cuando se registra en la plataforma, como su nombre, correo electrónico, nombre de la empresa y número de teléfono.',
                      ),

                      // Cláusula 2: Uso y Finalidad
                      _SectionTitle(title: '2. Uso de la Información'),
                      _SectionText(
                        text:
                            'Utilizamos su información para proporcionarle y mejorar nuestros servicios, emparejarlo con proveedores adecuados usando nuestro algoritmo Match IA, y enviarle comunicaciones relacionadas con el servicio.',
                      ),

                      // Cláusula 3: Compartir con Terceros
                      _SectionTitle(title: '3. Compartir Información'),
                      _SectionText(
                        text:
                            'Su información empresarial puede ser compartida con los proveedores a los que solicita cotizaciones. No vendemos ni alquilamos su información personal a terceros bajo ninguna circunstancia.',
                      ),

                      // Cláusula 4: Protocolos de Seguridad y Cifrado
                      _SectionTitle(title: '4. Seguridad de los Datos'),
                      _SectionText(
                        text:
                            'Implementamos medidas de seguridad de alto nivel, incluyendo encriptación de datos y protocolos seguros, para proteger su información contra acceso no autorizado y alteración.',
                      ),

                      // Cláusula 5: Derechos del Titular (ARCO)
                      _SectionTitle(title: '5. Sus Derechos'),
                      _SectionText(
                        text:
                            'Usted tiene el derecho de acceder, corregir o eliminar su información personal en cualquier momento a través de la configuración de su perfil o contactando a nuestro equipo de soporte.',
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

/// Título de sección para cada cláusula numerada del documento legal.
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

/// Párrafo de texto con tipografía legible y altura de línea adecuada para lectura legal.
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

