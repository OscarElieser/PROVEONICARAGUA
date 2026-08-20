import 'package:flutter/material.dart';
import '../../screens/about_us_screen.dart';
import '../theme/app_colors.dart';

class PremiumFooter extends StatelessWidget {
  const PremiumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Marca y Misión Corta
                  Column(
                    crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.trustGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.hub_outlined, color: AppColors.trustGreen, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'PROVEO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 300,
                        child: Text(
                          'El puente inteligente que conecta emprendedores y empresas con los mejores proveedores verificados de Nicaragua mediante Inteligencia Artificial.',
                          textAlign: isMobile ? TextAlign.center : TextAlign.left,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isMobile) const SizedBox(height: 32),

                  // Enlaces de Navegación
                  Wrap(
                    spacing: 48,
                    runSpacing: 32,
                    alignment: WrapAlignment.center,
                    children: [
                      _FooterLinkColumn(
                        title: 'Plataforma',
                        links: [
                          _FooterLinkItem(label: 'Inicio', onTap: () => Navigator.popUntil(context, (route) => route.isFirst)),
                          _FooterLinkItem(label: 'Proveedores', onTap: () {}), // Delegado a UI superior o ruta directa si es necesario
                          _FooterLinkItem(label: 'PROVEO Match IA', onTap: () {}),
                        ],
                      ),
                      _FooterLinkColumn(
                        title: 'Nosotros',
                        links: [
                          _FooterLinkItem(
                            label: 'Acerca de nosotros',
                            onTap: () {
                              // Si ya estamos en AboutUs, no hacemos push
                              if (ModalRoute.of(context)?.settings.name != '/about') {
                                Navigator.push(context, MaterialPageRoute(
                                  settings: const RouteSettings(name: '/about'),
                                  builder: (_) => const AboutUsScreen(),
                                ));
                              }
                            },
                          ),
                          _FooterLinkItem(label: 'Términos y Condiciones', onTap: () {}),
                          _FooterLinkItem(label: 'Política de Privacidad', onTap: () {}),
                        ],
                      ),
                      _FooterLinkColumn(
                        title: 'Soporte',
                        links: [
                          _FooterLinkItem(label: 'Centro de Ayuda', onTap: () {}),
                          _FooterLinkItem(label: 'Contacto', onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Divider(color: Colors.white24),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© ${DateTime.now().year} PROVEO Nicaragua. Todos los derechos reservados.',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.white.withValues(alpha: 0.5), size: 20),
                      const SizedBox(width: 16),
                      Icon(Icons.camera_alt_outlined, color: Colors.white.withValues(alpha: 0.5), size: 20),
                      const SizedBox(width: 16),
                      Icon(Icons.work_outline, color: Colors.white.withValues(alpha: 0.5), size: 20),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLinkColumn extends StatelessWidget {
  final String title;
  final List<_FooterLinkItem> links;

  const _FooterLinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        ...links,
      ],
    );
  }
}

class _FooterLinkItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLinkItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
