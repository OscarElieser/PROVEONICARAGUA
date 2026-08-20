import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'admin_dashboard_screen.dart';
import 'chat_screen.dart';
import 'match_screen.dart';
import 'provider_profile_screen.dart';
import 'search_screen.dart';

/// Home premium centrada en confianza, descubrimiento y PROVEO Match.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1000;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: desktop ? 36 : 20, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 20),
                  _Hero(desktop: desktop),
                  const SizedBox(height: 18),
                  const _Metrics(),
                  const SizedBox(height: 32),
                  const SectionTitle(title: '¿Cómo funciona PROVEO?', subtitle: 'Una forma más clara de encontrar y elegir proveedores'),
                  const SizedBox(height: 16),
                  const Wrap(spacing: 12, runSpacing: 12, children: [
                    _Step(number: '1', icon: Icons.search, title: 'Cuéntanos qué necesitas', text: 'Describe el producto o servicio.'),
                    _Step(number: '2', icon: Icons.auto_awesome_outlined, title: 'Recibe recomendaciones', text: 'Encontramos opciones para ti.'),
                    _Step(number: '3', icon: Icons.description_outlined, title: 'Compara y cotiza', text: 'Analiza precio y reputación.'),
                    _Step(number: '4', icon: Icons.handshake_outlined, title: 'Conecta y decide', text: 'Elige con mayor confianza.'),
                  ]),
                  const SizedBox(height: 32),
                  const SectionTitle(title: 'Proveedores destacados', subtitle: 'Empresas verificadas con reputación comprobada'),
                  const SizedBox(height: 16),
                  const _FeaturedProviders(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 680;
        final logoRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.hub_outlined, color: AppColors.successGreen),
            ),
            const SizedBox(width: 10),
            const Text(
              'PROVEO',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        );

        if (isMobile) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              logoRow,
              PopupMenuButton<int>(
                icon: const Icon(Icons.menu, color: AppColors.navy, size: 28),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.storefront_outlined, color: AppColors.navy.withValues(alpha: 0.7)),
                        const SizedBox(width: 12),
                        const Text('Proveedores'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.trustGreen.withValues(alpha: 0.9)),
                        const SizedBox(width: 12),
                        const Text('Match IA'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: AppColors.blue.withValues(alpha: 0.9)),
                        const SizedBox(width: 12),
                        const Text('Asistente IA'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: AppColors.navy.withValues(alpha: 0.9)),
                        const SizedBox(width: 12),
                        const Text('Panel Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                      break;
                    case 2:
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen()));
                      break;
                    case 3:
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                      break;
                    case 4:
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                      break;
                  }
                },
              ),
            ],
          );
        }

        return Row(
          children: [
            logoRow,
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: const Text('Proveedores'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())),
              icon: const Icon(Icons.auto_awesome, size: 16, color: AppColors.trustGreen),
              label: const Text('Match IA'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('Asistente IA'),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              style: FilledButton.styleFrom(backgroundColor: AppColors.paleBlue),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
              child: const Text('Panel Admin', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

class _Hero extends StatelessWidget {
  final bool desktop;
  const _Hero({required this.desktop});
  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.surface, AppColors.paleBlue]),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Flex(
        direction: desktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: desktop ? 6 : 0,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const VerifiedBadge(text: 'Red empresarial inteligente de Nicaragua'),
              const SizedBox(height: 16),
              Text(
                'Encuentra proveedores confiables para hacer crecer tu negocio.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.navy),
              ),
              const SizedBox(height: 12),
              const Text(
                'PROVEO es el puente inteligente que conecta emprendedores y empresas con los mejores proveedores verificados mediante IA.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.45),
              ),
              const SizedBox(height: 22),
              Wrap(spacing: 10, runSpacing: 10, children: [
                SizedBox(
                  width: desktop ? 340 : double.infinity,
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: '¿Qué producto o servicio necesitas?',
                    ),
                    onSubmitted: (val) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                    },
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on_outlined),
                  label: const Text('Nicaragua'),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Encontrar mi proveedor'),
                ),
              ]),
              const SizedBox(height: 16),
              const Wrap(spacing: 16, runSpacing: 8, children: [
                _Trust(icon: Icons.verified_outlined, text: 'Proveedores verificados'),
                _Trust(icon: Icons.bolt_outlined, text: 'Cotizaciones rápidas'),
                _Trust(icon: Icons.auto_awesome, text: 'Recomendaciones con Gemini IA'),
                _Trust(icon: Icons.shield_outlined, text: 'Información confiable'),
              ]),
            ]),
          ),
          if (desktop) const SizedBox(width: 28),
          if (desktop) const Expanded(child: _HeroVisual()),
        ],
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();
  @override
  Widget build(BuildContext context) => Container(
        height: 240,
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, AppColors.blue, AppColors.teal],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake_outlined, color: Colors.white, size: 70),
            const SizedBox(height: 12),
            const Text(
              'PROVEO MATCH IA',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Conectamos confianza, impulsamos negocios',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              style: FilledButton.styleFrom(backgroundColor: AppColors.trustGreen, foregroundColor: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
              child: const Text('Consultar a Gemini AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      );
}

class _Trust extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Trust({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: AppColors.trustGreen, size: 16), const SizedBox(width: 5), Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))]);
}

class _Metrics extends StatelessWidget {
  const _Metrics();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)), child: const Wrap(alignment: WrapAlignment.spaceAround, runSpacing: 18, children: [
        _Metric(value: '1,250+', label: 'Proveedores registrados', icon: Icons.people_alt_outlined),
        _Metric(value: '4,800+', label: 'Cotizaciones realizadas', icon: Icons.receipt_long_outlined),
        _Metric(value: '2,300+', label: 'Empresas conectadas', icon: Icons.hub_outlined),
        _Metric(value: '98%', label: 'Satisfacción de usuarios', icon: Icons.verified_outlined),
      ]));
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _Metric({required this.value, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(width: 190, child: Row(children: [Icon(icon, color: AppColors.successGreen, size: 30), const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))])]));
}

class _Step extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String text;
  const _Step({required this.number, required this.icon, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 620 ? double.infinity : 270.0;
    return SizedBox(
      width: cardWidth,
      child: PremiumCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: AppColors.paleGreen, child: Icon(icon, color: AppColors.trustGreen)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$number. $title', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProviders extends StatelessWidget {
  const _FeaturedProviders();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 780 ? double.infinity : 360.0;

    return FutureBuilder<List<ProviderModel>>(
      future: FirestoreRepository().getProviders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final cards = snapshot.data!.take(3).map((provider) {
          return SizedBox(
            width: cardWidth,
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.paleBlue,
                        child: Text(provider.name.substring(0, 1), style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                      const Icon(Icons.favorite_border, color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const VerifiedBadge(),
                  const SizedBox(height: 10),
                  Text(provider.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  RatingStars(rating: provider.rating),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: provider))),
                      child: const Text('Ver perfil'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
        return Wrap(spacing: 14, runSpacing: 14, children: cards);
      },
    );
  }
}
