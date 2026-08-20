import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'match_screen.dart';
import 'provider_profile_screen.dart';

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
  Widget build(BuildContext context) => Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.hub_outlined, color: AppColors.successGreen)),
        const SizedBox(width: 10),
        const Text('PROVEO', style: TextStyle(color: AppColors.navy, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text('Cómo funciona')),
        TextButton(onPressed: () {}, child: const Text('Proveedores')),
        IconButton(onPressed: () {}, tooltip: 'Notificaciones', icon: const Icon(Icons.notifications_none)),
        const CircleAvatar(radius: 17, backgroundColor: AppColors.paleBlue, child: Text('CG', style: TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w900))),
      ]);
}

class _Hero extends StatelessWidget {
  final bool desktop;
  const _Hero({required this.desktop});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.surface, AppColors.paleBlue]), borderRadius: BorderRadius.circular(26), border: Border.all(color: AppColors.border)),
        child: Flex(
          direction: desktop ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: desktop ? 6 : 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const VerifiedBadge(text: 'Red empresarial confiable'),
                const SizedBox(height: 16),
                Text('Encuentra proveedores confiables para hacer crecer tu negocio.', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.navy)),
                const SizedBox(height: 12),
                const Text('Conecta con empresas verificadas, compara opciones y toma decisiones con mayor confianza.', style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.45)),
                const SizedBox(height: 22),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  SizedBox(width: desktop ? 360 : double.infinity, child: const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: '¿Qué producto o servicio necesitas?'))),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.location_on_outlined), label: const Text('Managua')),
                  FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchScreen())), icon: const Icon(Icons.auto_awesome_outlined), label: const Text('Encontrar mi proveedor')),
                ]),
                const SizedBox(height: 16),
                const Wrap(spacing: 16, runSpacing: 8, children: [
                  _Trust(icon: Icons.verified_outlined, text: 'Proveedores verificados'),
                  _Trust(icon: Icons.bolt_outlined, text: 'Cotizaciones rápidas'),
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

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();
  @override
  Widget build(BuildContext context) => Container(height: 230, decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(22)), child: const Center(child: Icon(Icons.handshake_outlined, color: Colors.white, size: 96)));
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
  Widget build(BuildContext context) => SizedBox(width: 270, child: PremiumCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: AppColors.paleGreen, child: Icon(icon, color: AppColors.trustGreen)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('$number. $title', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]))])));
}

class _FeaturedProviders extends StatelessWidget {
  const _FeaturedProviders();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProviderModel>>(
      future: FirestoreRepository().getProviders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final cards = snapshot.data!.take(3).map((provider) {
          return SizedBox(
            width: 360,
            child: PremiumCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: AppColors.paleBlue, child: Text(provider.name.substring(0, 1), style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                  const Icon(Icons.favorite_border, color: AppColors.textSecondary),
                ]),
                const SizedBox(height: 12),
                const VerifiedBadge(),
                const SizedBox(height: 10),
                Text(provider.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                RatingStars(rating: provider.rating),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: provider))), child: const Text('Ver perfil'))),
              ]),
            ),
          );
        }).toList();
        return Wrap(spacing: 14, runSpacing: 14, children: cards);
      },
    );
  }
}
