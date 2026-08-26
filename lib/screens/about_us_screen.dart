// ==============================================================================
// PROVEO NICARAGUA - Pantalla Institucional / Quiénes Somos (lib/screens/about_us_screen.dart)
// ¿Qué hace?: Presenta la historia de la plataforma, misión empresarial, visión a largo plazo y valores corporativos.
// ¿Por qué se utiliza?: Comunica la identidad de marca, genera legitimidad y confianza institucional ante clientes e inversionistas.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_footer.dart';
import '../core/widgets/premium_header.dart';
import '../core/widgets/proveo_logo.dart';

/// Pantalla institucional con la historia, misión, visión y valores de PROVEO Nicaragua.
class AboutUsScreen extends StatelessWidget {
  /// Constructor constante
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Nosotros'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. SECCIÓN HERO: Título institucional y manifiesto de PROVEO
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blue, AppColors.teal],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.trustGreen.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const ProveoLogo(
                      variant: ProveoLogoVariant.extended,
                      height: 85,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nuestra Historia y Marca',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 700,
                    child: Text(
                      'PROVEO nace en Nicaragua con la visión de transformar la manera en que los negocios B2B interactúan. Somos el puente digital impulsado por Inteligencia Artificial que elimina fricciones, conecta empresas verificadas y potencia el crecimiento económico.',
                      style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. SECCIÓN: Misión y Visión Empresarial
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: const Wrap(
                    spacing: 32,
                    runSpacing: 32,
                    alignment: WrapAlignment.center,
                    children: [
                      _MissionVisionCard(
                        title: 'Nuestra Misión',
                        icon: Icons.rocket_launch_outlined,
                        description:
                            'Empoderar a emprendedores y empresas nicaragüenses facilitando el descubrimiento, conexión y negociación con proveedores confiables a través de tecnología inteligente y accesible.',
                      ),
                      _MissionVisionCard(
                        title: 'Nuestra Visión',
                        icon: Icons.visibility_outlined,
                        description:
                            'Ser la red empresarial B2B líder y más confiable de la región, donde cada conexión comercial sea segura, eficiente y potencie el desarrollo económico sostenible.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 3. SECCIÓN: Valores Fundamentales de la Marca
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: const Column(
                    children: [
                      Text(
                        'Nuestros Valores',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Los pilares que sostienen cada conexión en PROVEO',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      SizedBox(height: 48),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: [
                          _ValueCard(
                            icon: Icons.verified_user_outlined,
                            title: 'Confianza',
                            desc: 'Verificamos a cada actor para garantizar transacciones seguras.',
                          ),
                          _ValueCard(
                            icon: Icons.lightbulb_outline_rounded,
                            title: 'Innovación',
                            desc: 'Integramos IA de vanguardia para recomendaciones precisas.',
                          ),
                          _ValueCard(
                            icon: Icons.handshake_outlined,
                            title: 'Transparencia',
                            desc: 'Información clara y abierta para decisiones informadas.',
                          ),
                          _ValueCard(
                            icon: Icons.support_agent_outlined,
                            title: 'Servicio',
                            desc: 'Estamos comprometidos con el éxito de nuestros usuarios.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 4. PIE DE PÁGINA UNIVERSAL
          // ------------------------------------------------------------------
          const SliverToBoxAdapter(
            child: PremiumFooter(),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta estructurada para presentar la Misión o Visión institucional.
class _MissionVisionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _MissionVisionCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: AppColors.navy, size: 32),
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.navy)),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Tarjeta individual para presentar un valor corporativo con icono circular destacado.
class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _ValueCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: 36, color: AppColors.trustGreen),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.navy)),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

