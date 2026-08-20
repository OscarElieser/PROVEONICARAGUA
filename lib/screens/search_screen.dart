import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import '../core/widgets/premium_footer.dart';
import '../core/widgets/premium_header.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';

// ─── Constantes de categorías y ubicaciones ────────────────────────────────
const _kAllCategories = 'Todas las categorías';
const _kAllLocations = 'Todas las ubicaciones';
const List<String> _kCategories = [
  _kAllCategories, 'Empaques', 'Materia Prima', 'Logística', 'Tecnología',
  'Etiquetas', 'Manufactura',
];
const List<String> _kLocations = [
  _kAllLocations, 'Managua, Nicaragua', 'Masaya, Nicaragua',
  'León, Nicaragua', 'Chinandega, Nicaragua', 'Matagalpa, Nicaragua',
  'Granada, Nicaragua', 'Tipitapa, Nicaragua',
];

/// Buscador B2B premium con filtros funcionales y resultados desplazables.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = _kAllCategories;
  String _selectedLocation = _kAllLocations;
  double _minRating = 0;
  bool _onlyFeatured = false;
  final bool _filterPanelOpen = false; // para mobile
  String _activeCategory = _kAllCategories; // categoría visual seleccionada

  List<ProviderModel> _allProviders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    final data = await FirestoreRepository().getProviders();
    if (mounted) setState(() { _allProviders = data; _loading = false; });
  }

  List<ProviderModel> get _filtered {
    return _allProviders.where((p) {
      final q = _searchCtrl.text.toLowerCase();
      final matchesSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      final matchesCat = _selectedCategory == _kAllCategories ||
          p.category.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesActiveCat = _activeCategory == _kAllCategories ||
          p.category.toLowerCase().contains(_activeCategory.toLowerCase());
      final matchesLoc = _selectedLocation == _kAllLocations ||
          p.location == _selectedLocation;
      final matchesRating = p.rating >= _minRating;
      final matchesFeatured = !_onlyFeatured || p.featured;
      return matchesSearch && matchesCat && matchesActiveCat && matchesLoc && matchesRating && matchesFeatured;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchCtrl.clear();
      _selectedCategory = _kAllCategories;
      _selectedLocation = _kAllLocations;
      _minRating = 0;
      _onlyFeatured = false;
      _activeCategory = _kAllCategories;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Proveedores'),
      body: LayoutBuilder(builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;
        final results = _loading
            ? const Center(child: CircularProgressIndicator())
            : _ResultsPanel(
                providers: _filtered,
                searchCtrl: _searchCtrl,
                activeCategory: _activeCategory,
                onSearch: () => setState(() {}),
                onCategoryTap: (cat) => setState(() => _activeCategory = cat),
              );

        if (desktop) {
          return SingleChildScrollView(
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 270,
                        child: _FiltersPanel(
                          selectedCategory: _selectedCategory,
                          selectedLocation: _selectedLocation,
                          minRating: _minRating,
                          onlyFeatured: _onlyFeatured,
                          onCategoryChanged: (v) => setState(() => _selectedCategory = v ?? _kAllCategories),
                          onLocationChanged: (v) => setState(() => _selectedLocation = v ?? _kAllLocations),
                          onRatingChanged: (v) => setState(() => _minRating = v),
                          onFeaturedChanged: (v) => setState(() => _onlyFeatured = v),
                          onClear: _clearFilters,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: results,
                        ),
                      ),
                    ],
                  ),
                ),
                const PremiumFooter(),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (_filterPanelOpen)
              _FiltersPanel(
                selectedCategory: _selectedCategory,
                selectedLocation: _selectedLocation,
                minRating: _minRating,
                onlyFeatured: _onlyFeatured,
                onCategoryChanged: (v) => setState(() => _selectedCategory = v ?? _kAllCategories),
                onLocationChanged: (v) => setState(() => _selectedLocation = v ?? _kAllLocations),
                onRatingChanged: (v) => setState(() => _minRating = v),
                onFeaturedChanged: (v) => setState(() => _onlyFeatured = v),
                onClear: _clearFilters,
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [results, const SizedBox(height: 24), const PremiumFooter()],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Panel de Filtros ──────────────────────────────────────────────────────
class _FiltersPanel extends StatelessWidget {
  final String selectedCategory;
  final String selectedLocation;
  final double minRating;
  final bool onlyFeatured;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<double> onRatingChanged;
  final ValueChanged<bool> onFeaturedChanged;
  final VoidCallback onClear;

  const _FiltersPanel({
    required this.selectedCategory,
    required this.selectedLocation,
    required this.minRating,
    required this.onlyFeatured,
    required this.onCategoryChanged,
    required this.onLocationChanged,
    required this.onRatingChanged,
    required this.onFeaturedChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = selectedCategory != _kAllCategories ||
        selectedLocation != _kAllLocations ||
        minRating > 0 ||
        onlyFeatured;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(right: BorderSide(color: AppColors.border)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.tune_rounded, color: AppColors.navy, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Filtros', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.navy)),
              const Spacer(),
              if (hasActiveFilter)
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 15),
                  label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error, padding: EdgeInsets.zero),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('Categoría'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: _dropInputDec(),
            items: _kCategories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 18),
          _sectionLabel('Ubicación'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedLocation,
            decoration: _dropInputDec(),
            isExpanded: true,
            items: _kLocations.map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 12)))).toList(),
            onChanged: onLocationChanged,
          ),
          const SizedBox(height: 18),
          _sectionLabel('Calificación mínima'),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final val = (i + 1).toDouble();
              return GestureDetector(
                onTap: () => onRatingChanged(minRating == val ? 0 : val),
                child: Icon(
                  Icons.star_rounded,
                  color: val <= minRating ? AppColors.warning : AppColors.border,
                  size: 28,
                ),
              );
            }),
          ),
          if (minRating > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${minRating.toInt()} estrella${minRating > 1 ? 's' : ''} o más',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ),
          const SizedBox(height: 18),
          Row(
            children: [
              Switch.adaptive(
                value: onlyFeatured,
                onChanged: onFeaturedChanged,
                activeColor: AppColors.trustGreen,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Solo verificados / Top', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('Aplicar filtros', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(label,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary));

  InputDecoration _dropInputDec() => InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      );
}

// ─── Panel de Resultados ───────────────────────────────────────────────────
class _ResultsPanel extends StatelessWidget {
  final List<ProviderModel> providers;
  final TextEditingController searchCtrl;
  final String activeCategory;
  final VoidCallback onSearch;
  final ValueChanged<String> onCategoryTap;

  const _ResultsPanel({
    required this.providers,
    required this.searchCtrl,
    required this.activeCategory,
    required this.onSearch,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra de búsqueda
        TextField(
          controller: searchCtrl,
          onChanged: (_) => onSearch(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.navy),
            hintText: 'Buscar por nombre, producto o servicio...',
            hintStyle: const TextStyle(fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.navy, width: 2)),
          ),
        ),
        const SizedBox(height: 20),

        // Categorías visuales
        const Text('Explorar por Categorías', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navy)),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryChip(icon: Icons.apps_rounded, name: 'Todas', color: AppColors.navy, active: activeCategory == _kAllCategories, onTap: () => onCategoryTap(_kAllCategories)),
              _CategoryChip(icon: Icons.inventory_2_outlined, name: 'Empaques', color: AppColors.trustGreen, active: activeCategory == 'Empaques', onTap: () => onCategoryTap('Empaques')),
              _CategoryChip(icon: Icons.eco_outlined, name: 'Materia Prima', color: AppColors.teal, active: activeCategory == 'Materia Prima', onTap: () => onCategoryTap('Materia Prima')),
              _CategoryChip(icon: Icons.local_shipping_outlined, name: 'Logística', color: const Color(0xFF7B5EA7), active: activeCategory == 'Logística', onTap: () => onCategoryTap('Logística')),
              _CategoryChip(icon: Icons.computer_outlined, name: 'Tecnología', color: AppColors.blue, active: activeCategory == 'Tecnología', onTap: () => onCategoryTap('Tecnología')),
              _CategoryChip(icon: Icons.print_outlined, name: 'Etiquetas', color: const Color(0xFFDD6B20), active: activeCategory == 'Etiquetas', onTap: () => onCategoryTap('Etiquetas')),
              _CategoryChip(icon: Icons.precision_manufacturing_outlined, name: 'Manufactura', color: const Color(0xFF6B3FA0), active: activeCategory == 'Manufactura', onTap: () => onCategoryTap('Manufactura')),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Encabezado de resultados
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeCategory == _kAllCategories ? 'Todos los Proveedores' : activeCategory,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navy),
                  ),
                  Text(
                    '${providers.length} proveedor${providers.length != 1 ? 'es' : ''} encontrado${providers.length != 1 ? 's' : ''}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(10)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort_rounded, size: 15, color: AppColors.navy),
                  SizedBox(width: 4),
                  Text('Más relevantes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lista de proveedores
        if (providers.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 56, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Sin resultados', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary)),
                  SizedBox(height: 8),
                  Text('Intenta cambiar los filtros o el término de búsqueda.', style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        else
          ...providers.map((p) => _ProviderResultCard(provider: p)),
      ],
    );
  }
}

// ─── Chip de Categoría ─────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _CategoryChip({required this.icon, required this.name, required this.color, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? color : AppColors.border, width: active ? 2 : 1),
          boxShadow: active ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? Colors.white : color, size: 26),
            const SizedBox(height: 6),
            Text(name, textAlign: TextAlign.center, style: TextStyle(
              color: active ? Colors.white : AppColors.navy,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              fontSize: 11,
              height: 1.2,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta de Resultado ──────────────────────────────────────────────────
class _ProviderResultCard extends StatefulWidget {
  final ProviderModel provider;
  const _ProviderResultCard({required this.provider});
  @override
  State<_ProviderResultCard> createState() => _ProviderResultCardState();
}

class _ProviderResultCardState extends State<_ProviderResultCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.provider;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _hovered ? AppColors.blue : AppColors.border, width: _hovered ? 2 : 1),
          boxShadow: [BoxShadow(
            color: _hovered ? AppColors.blue.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.04),
            blurRadius: _hovered ? 20 : 8,
            offset: const Offset(0, 4),
          )],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.navy, AppColors.teal], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(p.logo.isNotEmpty ? p.logo.substring(0, p.logo.length.clamp(0, 2)) : p.name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Flexible(child: Text(p.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.navy))),
                          if (p.featured) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.trustGreen, borderRadius: BorderRadius.circular(8)),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.verified_rounded, color: Colors.white, size: 10),
                                SizedBox(width: 3),
                                Text('Top', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(p.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(width: 10),
                          Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.border, shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          const Icon(Icons.category_outlined, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(p.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ]),
                        const SizedBox(height: 6),
                        Row(children: [
                          ...List.generate(5, (i) => Icon(Icons.star_rounded, size: 15, color: i < p.rating.floor() ? AppColors.warning : AppColors.border)),
                          const SizedBox(width: 6),
                          Text('${p.rating} (${p.reviews} reseñas)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ]),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.paleGreen, borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.timer_outlined, size: 12, color: AppColors.trustGreen),
                          const SizedBox(width: 4),
                          Text('Resp: ${p.responseTime}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.trustGreen)),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Text('${p.years} años', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.navy),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: p))),
                    child: const Text('Ver perfil'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.trustGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())),
                    icon: const Icon(Icons.request_quote_outlined, size: 16),
                    label: const Text('Solicitar cotización'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
