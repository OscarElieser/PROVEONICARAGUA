import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/about_us_screen.dart';
import '../../screens/contact_screen.dart';
import '../../screens/help_center_screen.dart';
import '../../screens/match_screen.dart';
import '../../screens/privacy_policy_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/terms_conditions_screen.dart';
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
                          _FooterLinkItem(
                            label: 'Proveedores', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/search') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen(), settings: const RouteSettings(name: '/search')));
                              }
                            }
                          ),
                          _FooterLinkItem(
                            label: 'PROVEO Match IA', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/match') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen(), settings: const RouteSettings(name: '/match')));
                              }
                            }
                          ),
                        ],
                      ),
                      _FooterLinkColumn(
                        title: 'Nosotros',
                        links: [
                          _FooterLinkItem(
                            label: 'Acerca de nosotros',
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/about') {
                                Navigator.push(context, MaterialPageRoute(
                                  settings: const RouteSettings(name: '/about'),
                                  builder: (_) => const AboutUsScreen(),
                                ));
                              }
                            },
                          ),
                          _FooterLinkItem(
                            label: 'Términos y Condiciones', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/terms') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen(), settings: const RouteSettings(name: '/terms')));
                              }
                            }
                          ),
                          _FooterLinkItem(
                            label: 'Política de Privacidad', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/privacy') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen(), settings: const RouteSettings(name: '/privacy')));
                              }
                            }
                          ),
                        ],
                      ),
                      _FooterLinkColumn(
                        title: 'Soporte',
                        links: [
                          _FooterLinkItem(
                            label: 'Centro de Ayuda', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/help') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen(), settings: const RouteSettings(name: '/help')));
                              }
                            }
                          ),
                          _FooterLinkItem(
                            label: 'Contacto', 
                            onTap: () {
                              if (ModalRoute.of(context)?.settings.name != '/contact') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen(), settings: const RouteSettings(name: '/contact')));
                              }
                            }
                          ),
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
                  const Row(
                    children: [
                      _SocialIcon(
                        icon: Icons.facebook, 
                        url: 'https://facebook.com/proveonicaragua',
                      ),
                      SizedBox(width: 16),
                      _SocialIcon(
                        icon: Icons.camera_alt_outlined, 
                        url: 'https://instagram.com/proveonicaragua',
                      ),
                      SizedBox(width: 16),
                      _SocialIcon(
                        icon: Icons.work_outline, 
                        url: 'https://linkedin.com/company/proveonicaragua',
                      ),
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

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir el enlace.')),
            );
          }
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 24),
      ),
    );
  }
}
