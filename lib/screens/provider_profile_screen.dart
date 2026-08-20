import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import 'catalog_screen.dart';
import 'quotation_request_screen.dart';

/// Ficha empresarial con reputacion y acciones comerciales.
class ProviderProfileScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderProfileScreen({super.key, required this.provider});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(provider.name)),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(radius: 34, backgroundColor: AppColors.paleBlue, child: Text(provider.name.substring(0, 1), style: const TextStyle(fontSize: 24, color: AppColors.navy, fontWeight: FontWeight.w900))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(provider.name, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 6), const VerifiedBadge(), const SizedBox(height: 6), Text(provider.location)]))]),
        const SizedBox(height: 20), Text(provider.description), const SizedBox(height: 14), RatingStars(rating: provider.rating), Text('${provider.reviews} reseñas verificadas  •  ${provider.years} años de experiencia  •  Responde en ${provider.responseTime}'), const SizedBox(height: 20),
        Row(children: [Expanded(child: FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())), icon: const Icon(Icons.request_quote_outlined), label: const Text('Solicitar cotización'))), const SizedBox(width: 10), OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen())), child: const Text('Catálogo'))]),
      ])),
      const SizedBox(height: 20), const SectionTitle(title: 'Círculo Dorado', subtitle: 'Reputación empresarial PROVEO'), const SizedBox(height: 12),
      const PremiumCard(child: Column(children: [ListTile(title: Text('Calidad'), trailing: Text('4.9 / 5')), ListTile(title: Text('Cumplimiento'), trailing: Text('4.8 / 5')), ListTile(title: Text('Atención'), trailing: Text('4.7 / 5')), ListTile(title: Text('Relación calidad-precio'), trailing: Text('4.6 / 5'))])),
    ]),
  );
}