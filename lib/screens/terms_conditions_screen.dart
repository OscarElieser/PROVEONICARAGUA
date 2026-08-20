import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Términos y Condiciones'),
      body: CustomScrollView(
        slivers: [
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
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(title: '1. Aceptación de los Términos'),
                      _SectionText(
                          text:
                              'Al acceder y utilizar PROVEO Nicaragua, usted acepta estar sujeto a estos Términos y Condiciones y a nuestra Política de Privacidad. Si no está de acuerdo con alguna parte de los términos, no podrá acceder al servicio.'),
                      _SectionTitle(title: '2. Descripción del Servicio'),
                      _SectionText(
                          text:
                              'PROVEO es una plataforma B2B que conecta a empresas y emprendedores en Nicaragua con proveedores verificados, facilitando el proceso de cotización y negociación a través de herramientas de Inteligencia Artificial.'),
                      _SectionTitle(title: '3. Uso de la Plataforma'),
                      _SectionText(
                          text:
                              'Usted se compromete a utilizar la plataforma de manera ética y legal. Está estrictamente prohibido proporcionar información falsa, intentar vulnerar la seguridad del sitio o utilizar la plataforma para actividades ilícitas.'),
                      _SectionTitle(title: '4. Cuentas y Seguridad'),
                      _SectionText(
                          text:
                              'Usted es responsable de salvaguardar la contraseña que utiliza para acceder al servicio y de cualquier actividad o acción bajo su contraseña. Debe notificarnos inmediatamente si detecta alguna violación de seguridad o uso no autorizado de su cuenta.'),
                      _SectionTitle(title: '5. Verificación de Proveedores'),
                      _SectionText(
                          text:
                              'Aunque nos esforzamos por verificar a todos los proveedores, PROVEO no garantiza la ejecución final de los contratos entre las partes. La plataforma actúa como un puente de conexión.'),
                      _SectionTitle(title: '6. Modificaciones'),
                      _SectionText(
                          text:
                              'Nos reservamos el derecho, a nuestra sola discreción, de modificar o reemplazar estos Términos en cualquier momento. Revisaremos la fecha de "Última actualización" en la parte superior de esta página.'),
                      SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: PremiumFooter()),
        ],
      ),
    );
  }
}

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
