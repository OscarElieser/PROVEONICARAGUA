import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';
import '../core/widgets/premium_footer.dart';

/// Buscador B2B interactivo y responsive con filtros funcionales en tiempo real.
class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.initialCategory,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreRepository _repository = FirestoreRepository();

  String _selectedCategory = 'Todas las categorías';
  String _selectedLocation = 'Todos los departamentos';
  double _minRating = 0.0;
  String _sortBy = 'Más relevantes';

  List<ProviderModel> _allProviders = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Todas las categorías', 'label': 'Todas', 'icon': Icons.all_inclusive_rounded, 'color': AppColors.navy},
    {'name': 'Empaques', 'label': 'Empaques\ny Envases', 'icon': Icons.inventory_2_outlined, 'color': AppColors.trustGreen},
    {'name': 'Materia Prima', 'label': 'Materia\nPrima', 'icon': Icons.eco_outlined, 'color': AppColors.teal},
    {'name': 'Logística y Transporte', 'label': 'Logística\ny Transporte', 'icon': Icons.local_shipping_outlined, 'color': AppColors.navy},
    {'name': 'Etiquetas y Publicidad', 'label': 'Etiquetas\ny Publicidad', 'icon': Icons.print_outlined, 'color': AppColors.blue},
    {'name': 'Tecnología B2B', 'label': 'Tecnología\nB2B', 'icon': Icons.computer_outlined, 'color': AppColors.warning},
  ];

  final List<String> _locations = [
    'Todos los departamentos',
    'Managua',
    'Masaya',
    'León',
    'Chinandega',
    'Matagalpa',
    'Estelí',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    final data = await _repository.getProviders();
    if (mounted) {
      setState(() {
        _allProviders = data;
        _isLoading = false;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Todas las categorías';
      _selectedLocation = 'Todos los departamentos';
      _minRating = 0.0;
      _sortBy = 'Más relevantes';
    });
  }

  List<ProviderModel> get _filteredProviders {
    final query = _searchController.text.trim().toLowerCase();

    return _allProviders.where((provider) {
      // Filtro de Texto
      if (query.isNotEmpty) {
        final matchesName = provider.name.toLowerCase().contains(query);
        final matchesDesc = provider.description.toLowerCase().contains(query);
        final matchesCategory = provider.category.toLowerCase().contains(query);
        final matchesLoc = provider.location.toLowerCase().contains(query);
        if (!matchesName && !matchesDesc && !matchesCategory && !matchesLoc) {
          return false;
        }
      }

      // Filtro de Categoría
      if (_selectedCategory != 'Todas las categorías') {
        if (!provider.category.toLowerCase().contains(_selectedCategory.toLowerCase()) &&
            !_selectedCategory.toLowerCase().contains(provider.category.toLowerCase())) {
          return false;
        }
      }

      // Filtro de Ubicación
      if (_selectedLocation != 'Todos los departamentos') {
        if (!provider.location.toLowerCase().contains(_selectedLocation.toLowerCase())) {
          return false;
        }
      }

      // Filtro de Calificación
      if (_minRating > 0.0 && provider.rating < _minRating) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'Mejor calificados') {
          return b.rating.compareTo(a.rating);
        } else if (_sortBy == 'Más reseñas') {
          return b.reviews.compareTo(a.reviews);
        }
        return (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0);
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Directorio de Proveedores B2B'),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 960;
          final filtered = _filteredProviders;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 16,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── BARRA DE BÚSQUEDA Y CATEGORÍAS RÁPIDAS ──────────────────
                          _buildSearchHeader(),
                          const SizedBox(height: 24),

                          // ── CONTENIDO PRINCIPAL (FILTROS + LISTA) ───────────────────
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 280,
                                  child: _buildFiltersSidebar(),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildResultsList(filtered),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildMobileFiltersToggle(),
                                const SizedBox(height: 16),
                                _buildResultsList(filtered),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const PremiumFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Header de Búsqueda y Carrusel de Categorías ───────────────────────────
  Widget _buildSearchHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buscador Central
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar por producto, servicio, material o nombre de empresa...',
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.navy, size: 24),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Carrusel de Categorías
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Explorar por Categorías',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
              ),
            ),
            if (_selectedCategory != 'Todas las categorías')
              TextButton.icon(
                onPressed: () => setState(() => _selectedCategory = 'Todas las categorías'),
                icon: const Icon(Icons.close, size: 14),
                label: const Text('Ver todas', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat['name'];
              final color = cat['color'] as Color;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat['name'] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 125,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? color.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.02),
                          blurRadius: isSelected ? 10 : 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: isSelected ? Colors.white : color,
                          size: 26,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.navy,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                            fontSize: 11,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Sidebar de Filtros (Desktop) ──────────────────────────────────────────
  Widget _buildFiltersSidebar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 20, color: AppColors.navy),
                  SizedBox(width: 8),
                  Text(
                    'Filtros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navy),
                  ),
                ],
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Limpiar', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue)),
              ),
            ],
          ),
          const Divider(height: 24),

          // Filtro Categoría
          const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.navy)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              filled: true,
              fillColor: AppColors.background,
            ),
            items: _categories.map((c) {
              return DropdownMenuItem<String>(
                value: c['name'] as String,
                child: Text(c['name'] as String, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 18),

          // Filtro Ubicación
          const Text('Ubicación en Nicaragua', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.navy)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              filled: true,
              fillColor: AppColors.background,
            ),
            items: _locations.map((loc) {
              return DropdownMenuItem<String>(
                value: loc,
                child: Text(loc, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedLocation = val);
            },
          ),
          const SizedBox(height: 18),

          // Filtro Calificación Mínima
          const Text('Calificación Mínima', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.navy)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ratingChip('Todas', 0.0),
              _ratingChip('4.0+ ★', 4.0),
              _ratingChip('4.5+ ★', 4.5),
              _ratingChip('4.8+ ★', 4.8),
            ],
          ),
          const SizedBox(height: 24),

          // Botón Aplicar / Restablecer
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Aplicar filtros', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingChip(String label, double rating) {
    final isSelected = _minRating == rating;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.warning.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
        color: isSelected ? const Color(0xFFB7791F) : AppColors.textPrimary,
      ),
      side: BorderSide(color: isSelected ? AppColors.warning : AppColors.border),
      onSelected: (_) {
        setState(() => _minRating = rating);
      },
    );
  }

  // ── Filtros en Móvil ───────────────────────────────────────────────────────
  Widget _buildMobileFiltersToggle() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (ctx) => StatefulBuilder(
                    builder: (context, setModalState) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFiltersSidebar(),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cerrar y Ver Resultados'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text('Filtrar y Ordenar'),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  // ── Lista de Resultados ────────────────────────────────────────────────────
  Widget _buildResultsList(List<ProviderModel> providers) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado de Resultados y Ordenamiento
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${providers.length} ${providers.length == 1 ? 'proveedor encontrado' : 'proveedores encontrados'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedCategory != 'Todas las categorías'
                      ? 'Filtrado por: $_selectedCategory'
                      : 'Empresas verificadas y activas en Nicaragua',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            DropdownButton<String>(
              value: _sortBy,
              underline: const SizedBox(),
              icon: const Icon(Icons.sort_rounded, color: AppColors.navy),
              style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'Más relevantes', child: Text('Más relevantes')),
                DropdownMenuItem(value: 'Mejor calificados', child: Text('Mejor calificados')),
                DropdownMenuItem(value: 'Más reseñas', child: Text('Más reseñas')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Lista de Proveedores
        if (providers.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.paleBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.navy),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No se encontraron proveedores con estos filtros',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navy),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Intenta cambiar la categoría, ubicación o limpiar los términos de búsqueda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                FilledButton.tonal(
                  onPressed: _clearFilters,
                  child: const Text('Restablecer todos los filtros'),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView exterior
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return _ProviderItemCard(provider: provider);
            },
          ),
      ],
    );
  }
}

// ── Tarjeta de Proveedor Ultra-Premium ───────────────────────────────────────
class _ProviderItemCard extends StatefulWidget {
  final ProviderModel provider;
  const _ProviderItemCard({required this.provider});

  @override
  State<_ProviderItemCard> createState() => _ProviderItemCardState();
}

class _ProviderItemCardState extends State<_ProviderItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.provider;
    final isMobile = MediaQuery.of(context).size.width < 720;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppColors.blue : AppColors.border,
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.navy.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                // Avatar / Logo
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.navy, AppColors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          p.name.length >= 2 ? p.name.substring(0, 2).toUpperCase() : 'PR',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    if (isMobile) ...[
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${p.category} • ${p.location}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                if (!isMobile) const SizedBox(width: 20),

                // Información Detallada
                if (!isMobile)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (p.featured)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.trustGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded, size: 12, color: AppColors.trustGreen),
                                    SizedBox(width: 4),
                                    Text(
                                      'Verificado',
                                      style: TextStyle(
                                        color: AppColors.trustGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingStars(rating: p.rating),
                            const SizedBox(width: 8),
                            Text(
                              '${p.rating} (${p.reviews} reseñas)',
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('•', style: TextStyle(color: AppColors.border)),
                            const SizedBox(width: 12),
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(p.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                if (isMobile) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingStars(rating: p.rating),
                      const SizedBox(width: 8),
                      Text('${p.rating} (${p.reviews})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                ],

                if (!isMobile) const SizedBox(width: 24),

                // Acciones y Tiempo de Respuesta
                Column(
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: AppColors.trustGreen),
                        const SizedBox(width: 4),
                        Text(
                          'Resp: ${p.responseTime}',
                          style: const TextStyle(
                            color: AppColors.trustGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.navy,
                            side: const BorderSide(color: AppColors.navy),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProviderProfileScreen(provider: p),
                              ),
                            );
                          },
                          child: const Text('Ver perfil', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.trustGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuotationRequestScreen(),
                              ),
                            );
                          },
                          child: const Text('Solicitar cotización', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
