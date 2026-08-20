import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';
import '../core/widgets/premium_footer.dart';

/// Buscador B2B responsive con filtros y resultados premium.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Buscar proveedores')),
        body: LayoutBuilder(builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;
          const results = _ResultsPanel(); // Constante en tiempo de compilacion para evitar reconstrucciones innecesarias
          if (!desktop) return ListView(children: const [Padding(padding: EdgeInsets.all(20), child: results), PremiumFooter()]);
          // Retorna layout de dos columnas: panel de filtros a la izquierda y resultados a la derecha
          return const SingleChildScrollView(
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 250, child: _FiltersPanel()), Expanded(child: Padding(padding: EdgeInsets.all(24), child: results))]),
                PremiumFooter(),
              ],
            ),
          );
        }),
      );
}

class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel();
  @override
  Widget build(BuildContext context) => Container(
      // Contenedor del panel de filtros lateral
      padding: const EdgeInsets.fromLTRB(24, 20, 18, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface, // Fondo blanco del panel
        border: Border(right: BorderSide(color: AppColors.border)), // Borde derecho separador
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Fila encabezado con titulo y boton limpiar
        Row(children: [
          Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Limpiar')),
        ]),
        const SizedBox(height: 18),
        // Filtro de categoria
        const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: 'Todas las categorías', // 'value' es el parametro correcto (no 'initialValue')
          items: const [
            DropdownMenuItem(value: 'Todas las categorías', child: Text('Todas las categorías')),
            DropdownMenuItem(value: 'Empaques', child: Text('Empaques')),
          ],
          onChanged: null, // Deshabilitado por ahora, se habilita con logica de filtros
        ),
        const SizedBox(height: 16),
        // Filtro de ubicacion
        const Text('Ubicación', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: 'Managua', // 'value' es el parametro correcto (no 'initialValue')
          items: const [
            DropdownMenuItem(value: 'Managua', child: Text('Managua')),
            DropdownMenuItem(value: 'Masaya', child: Text('Masaya')),
          ],
          onChanged: null, // Deshabilitado por ahora
        ),
        const SizedBox(height: 16),
        // Filtro de calificacion minima
        const Text('Calificación mínima', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('★★★★☆  4 estrellas o más', style: TextStyle(color: AppColors.warning)),
        const SizedBox(height: 18),
        // Boton para aplicar todos los filtros seleccionados
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () {}, child: const Text('Aplicar filtros')),
        ),
      ]),
    );
}

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: [
      const Text('Explorar por Categorías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 16),
      SizedBox(
        height: 110,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            _CategoryCard(icon: Icons.inventory_2_outlined, name: 'Empaques\ny Envases', color: AppColors.trustGreen, active: true),
            _CategoryCard(icon: Icons.eco_outlined, name: 'Materia\nPrima', color: AppColors.teal),
            _CategoryCard(icon: Icons.local_shipping_outlined, name: 'Logística\ny Transporte', color: AppColors.navy),
            _CategoryCard(icon: Icons.print_outlined, name: 'Etiquetas\ny Publicidad', color: AppColors.blue),
            _CategoryCard(icon: Icons.computer_outlined, name: 'Tecnología\nB2B', color: AppColors.warning),
          ],
        ),
      ),
      const SizedBox(height: 24),
      const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar productos, servicios o proveedores')), 
      const SizedBox(height: 18), 
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Resultados de Empaques', style: Theme.of(context).textTheme.titleLarge), const Text('Proveedores confiables encontrados', style: TextStyle(color: AppColors.textSecondary))])), 
        const Chip(label: Text('Más relevantes'))
      ]), 
      const SizedBox(height: 16), 
      FutureBuilder<List<ProviderModel>>(
        future: FirestoreRepository().getProviders(), 
        builder: (context, snapshot) { 
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator()); 
          return Column(children: snapshot.data!.map((provider) => _ProviderResult(provider: provider)).toList()); 
        }
      )
    ]
  );
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final bool active;

  const _CategoryCard({required this.icon, required this.name, required this.color, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: active ? color : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? color : AppColors.border),
        boxShadow: active ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: active ? Colors.white : color, size: 28),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : AppColors.navy,
                    fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderResult extends StatelessWidget {
  final ProviderModel provider;
  const _ProviderResult({required this.provider});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 14), child: PremiumCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 28, backgroundColor: AppColors.paleBlue, child: Text(provider.name.substring(0, 1), style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(provider.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const VerifiedBadge(), const SizedBox(height: 6), RatingStars(rating: provider.rating), Text(provider.location, style: const TextStyle(color: AppColors.textSecondary)), Text(provider.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary))])), const SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(provider.responseTime, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 12), OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: provider))), child: const Text('Ver perfil')), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())), child: const Text('Solicitar cotización'))])])));
}
