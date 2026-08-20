import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';

/// Buscador B2B responsive con filtros y resultados premium.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Buscar proveedores')),
        body: LayoutBuilder(builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;
          final results = const _ResultsPanel();
          if (!desktop) return ListView(padding: const EdgeInsets.all(20), children: [const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar productos, servicios o proveedores')), const SizedBox(height: 14), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.tune), label: const Text('Filtros y orden')), const SizedBox(height: 20), results]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(width: 250, child: _FiltersPanel()), Expanded(child: Padding(padding: const EdgeInsets.only(left: 24), child: results))]);
        }),
      );
}

class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(24, 20, 18, 24), decoration: const BoxDecoration(color: AppColors.surface, border: Border(right: BorderSide(color: AppColors.border))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('Filtros', style: Theme.of(context).textTheme.titleLarge), const Spacer(), TextButton(onPressed: () {}, child: const Text('Limpiar'))]), const SizedBox(height: 18), const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), DropdownButtonFormField<String>(initialValue: 'Todas las categorías', items: const [DropdownMenuItem(value: 'Todas las categorías', child: Text('Todas las categorías')), DropdownMenuItem(value: 'Empaques', child: Text('Empaques'))], onChanged: null), const SizedBox(height: 16), const Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), DropdownButtonFormField<String>(initialValue: 'Managua', items: const [DropdownMenuItem(value: 'Managua', child: Text('Managua')), DropdownMenuItem(value: 'Masaya', child: Text('Masaya'))], onChanged: null), const SizedBox(height: 16), const Text('Calificación mínima', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), const Text('★★★★☆  4 estrellas o más', style: TextStyle(color: AppColors.warning)), const SizedBox(height: 18), SizedBox(width: double.infinity, child: FilledButton(onPressed: () {}, child: const Text('Aplicar filtros')))]));
}

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar productos, servicios o proveedores')), const SizedBox(height: 18), Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Resultados para “empaque plástico”', style: Theme.of(context).textTheme.titleLarge), const Text('Proveedores confiables encontrados', style: TextStyle(color: AppColors.textSecondary))])), const Chip(label: Text('Más relevantes'))]), const SizedBox(height: 16), FutureBuilder<List<ProviderModel>>(future: FirestoreRepository().getProviders(), builder: (context, snapshot) { if (!snapshot.hasData) return const Center(child: CircularProgressIndicator()); return Column(children: snapshot.data!.map((provider) => _ProviderResult(provider: provider)).toList()); })]);
}

class _ProviderResult extends StatelessWidget {
  final ProviderModel provider;
  const _ProviderResult({required this.provider});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 14), child: PremiumCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 28, backgroundColor: AppColors.paleBlue, child: Text(provider.name.substring(0, 1), style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(provider.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const VerifiedBadge(), const SizedBox(height: 6), RatingStars(rating: provider.rating), Text(provider.location, style: const TextStyle(color: AppColors.textSecondary)), Text(provider.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary))])), const SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(provider.responseTime, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 12), OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: provider))), child: const Text('Ver perfil')), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())), child: const Text('Solicitar cotización'))])])));
}
