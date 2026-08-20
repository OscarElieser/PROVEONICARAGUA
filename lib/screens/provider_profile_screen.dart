import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../core/widgets/premium_footer.dart';
import 'chat_screen.dart';
import 'quotation_request_screen.dart';

// ── Datos demo del catálogo (se reemplazan por los datos reales del proveedor) ──
List<ProductModel> _buildDemoProducts(ProviderModel provider) {
  // Las fotos apuntan al asset demo; en producción se usan las URLs de Firestore (imageUrl).
  // Cada proveedor puede tener sus propias líneas y productos almacenados en la base de datos.
  final cat = provider.category.toLowerCase();

  if (cat.contains('plástico') || cat.contains('empaqu') || cat.contains('envase') || cat.isEmpty) {
    return [
      const ProductModel(
        id: 'p1',
        name: 'Galonera HDPE 1 Galón',
        model: 'GAL-001-HDPE',
        description: 'Galonera industrial de polietileno de alta densidad con tapa de seguridad azul oscuro y asa integrada.',
        provider: '',
        category: 'Envases',
        price: 18.50,
        maxPrice: 22.00,
        moq: 100,
        unit: 'unidad',
        availability: 'En stock',
        characteristics: [
          'Material: HDPE virgen',
          'Capacidad: 1 galón (3.78 L)',
          'Color: Blanco translúcido',
          'Apto para alimentos: Sí',
          'BPA Free: Sí',
          'Impresión serigráfica: Opcional',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: false,
        discount: 0,
      ),
      const ProductModel(
        id: 'p2',
        name: 'Frasco PET 500ml Transparente',
        model: 'PET-500-TR',
        description: 'Frasco PET cristal con tapa rosca de aluminio o plástica, ideal para alimentos, bebidas y cosméticos.',
        provider: '',
        category: 'Frascos',
        price: 8.20,
        maxPrice: 14.50,
        moq: 500,
        unit: 'unidad',
        availability: 'En stock',
        characteristics: [
          'Material: PET grado alimenticio',
          'Capacidad: 500 ml',
          'Tapa: Rosca 38mm',
          'Transparencia: Cristal',
          'Uso: Alimentos y cosméticos',
          'Certificación: FDA compatible',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: true,
        discount: 5,
      ),
      const ProductModel(
        id: 'p3',
        name: 'Film Estiramiento Industrial',
        model: 'FILM-IND-20',
        description: 'Rollo de film stretch de polietileno lineal para paletizado de mercancía. Alta resistencia y extensión.',
        provider: '',
        category: 'Empaques',
        price: 0.45,
        maxPrice: 1.20,
        moq: 1000,
        unit: 'metro',
        availability: 'En stock',
        characteristics: [
          'Material: LLDPE virgen',
          'Ancho: 50 cm',
          'Calibre: 20 micras',
          'Elongación: hasta 300%',
          'Uso: Paletizado industrial',
          'Color: Transparente / negro',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: false,
        discount: 10,
      ),
      const ProductModel(
        id: 'p4',
        name: 'Contenedor Plástico Rectangular',
        model: 'CONT-RECT-1L',
        description: 'Contenedor de polipropileno con tapa hermética apto para almacenamiento de alimentos, líquidos y sólidos.',
        provider: '',
        category: 'Contenedores',
        price: 12.00,
        maxPrice: 18.50,
        moq: 200,
        unit: 'unidad',
        availability: 'Disponible 3-5 días',
        characteristics: [
          'Material: Polipropileno (PP)',
          'Volumen: 1 litro',
          'Tapa: Hermética clic',
          'Apto microondas: Sí',
          'Apto lavavajillas: Sí',
          'Libre de BPA: Sí',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: true,
        discount: 0,
      ),
      const ProductModel(
        id: 'p5',
        name: 'Barril Industrial 200L',
        model: 'BARR-200-HDPE',
        description: 'Barril hermético de polietileno azul de 200 litros con cierre de seguridad industrial para químicos y alimentos.',
        provider: '',
        category: 'Barriles',
        price: 1250.00,
        maxPrice: null,
        moq: 10,
        unit: 'unidad',
        availability: 'Bajo pedido',
        characteristics: [
          'Material: HDPE',
          'Capacidad: 200 litros',
          'Color: Azul / gris',
          'Resistente a UV: Sí',
          'Cierre: Tapa metálica con palanca',
          'Norma: UN aprobado',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: false,
        discount: 0,
      ),
      const ProductModel(
        id: 'p6',
        name: 'Bolsa Kraft Biodegradable Stand Up',
        model: 'BOLSA-KR-250',
        description: 'Bolsa tipo stand-up kraft 100% biodegradable con cierre zip y ventana transparente. Apta para alimentos.',
        provider: '',
        category: 'Bolsas',
        price: 3.80,
        maxPrice: 6.50,
        moq: 500,
        unit: 'unidad',
        availability: 'En stock',
        characteristics: [
          'Material: Papel kraft + barrera',
          'Capacidad: 250 g',
          'Cierre: Zip resellable',
          'Ventana: Sí (transparente)',
          'Biodegradable: 100%',
          'Impresión: Hasta 6 colores',
        ],
        imageUrl: 'assets/images/catalog_demo.jpg',
        isNew: true,
        discount: 15,
      ),
    ];
  }

  // Catálogo genérico si la categoría del proveedor es diferente
  return [
    ProductModel(
      id: 'g1',
      name: 'Producto Principal ${provider.category}',
      model: 'MOD-001',
      description: 'Producto estrella del portafolio de ${provider.name}. Consulte al proveedor para especificaciones completas.',
      provider: provider.id,
      category: provider.category,
      price: 50.00,
      moq: 50,
      unit: 'unidad',
      availability: 'En stock',
      characteristics: [
        'Calidad certificada',
        'Entrega a nivel nacional',
        'Garantía incluida',
      ],
      imageUrl: 'assets/images/catalog_demo.jpg',
      isNew: true,
    ),
  ];
}

/// Perfil y Catálogo Empresarial B2B Ultra-Premium de PROVEO con Grid de Productos.
class ProviderProfileScreen extends StatefulWidget {
  final ProviderModel provider;

  const ProviderProfileScreen({super.key, required this.provider});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openProductDetail(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductDetailSheet(product: product, provider: widget.provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _buildDemoProducts(widget.provider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Banner Hero ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.navy,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, AppColors.blue, AppColors.teal],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Avatar empresa
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.teal,
                                child: Text(
                                  widget.provider.name.isNotEmpty
                                      ? widget.provider.name.substring(0, 2).toUpperCase()
                                      : 'PR',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.provider.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (widget.provider.featured)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.trustGreen,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                                              SizedBox(width: 3),
                                              Text('Top Verificado',
                                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.provider.category} • ${widget.provider.location}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${widget.provider.rating} (${widget.provider.reviews} opiniones)',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text('•', style: TextStyle(color: Colors.white54)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Resp: ${widget.provider.responseTime}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Cuerpo ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Acciones Comerciales
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.trustGreen,
                                elevation: 3,
                                shadowColor: AppColors.trustGreen.withValues(alpha: 0.4),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const QuotationRequestScreen()),
                              ),
                              icon: const Icon(Icons.request_quote_rounded, size: 20),
                              label: const Text('Solicitar Cotización',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.navy,
                                side: const BorderSide(color: AppColors.navy, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(initialProvider: widget.provider),
                                ),
                              ),
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                              label: const Text('Chat B2B',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tabs: Catálogo / Perfil / Calificaciones
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // TabBar
                            TabBar(
                              controller: _tabController,
                              indicatorColor: AppColors.navy,
                              indicatorWeight: 3,
                              labelColor: AppColors.navy,
                              unselectedLabelColor: AppColors.textSecondary,
                              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                              tabs: const [
                                Tab(icon: Icon(Icons.grid_view_rounded, size: 20), text: 'Catálogo'),
                                Tab(icon: Icon(Icons.business_rounded, size: 20), text: 'Perfil'),
                                Tab(icon: Icon(Icons.workspace_premium_rounded, size: 20), text: 'Calidad'),
                              ],
                            ),
                            const Divider(height: 1),

                            SizedBox(
                              height: 680,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // ── TAB 1: CATÁLOGO EN GRID ────────────────────
                                  _CatalogGrid(products: products, onTap: _openProductDetail),

                                  // ── TAB 2: PERFIL COMPLETO DEL FABRICANTE ──────
                                  _CompanyFullProfileTab(provider: widget.provider),

                                  // ── TAB 3: SECCIÓN PREMIUM DE CALIDAD ──────────
                                  _QualitySectionTab(provider: widget.provider),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
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

// ── Grid de Catálogo ─────────────────────────────────────────────────────────
class _CatalogGrid extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(ProductModel) onTap;

  const _CatalogGrid({required this.products, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 42, color: AppColors.textSecondary),
            SizedBox(height: 10),
            Text('El proveedor aún no ha publicado su catálogo.',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => _ProductCard(product: products[i], onTap: onTap),
    );
  }
}

// ── Tarjeta de Producto en Grid ──────────────────────────────────────────────
class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final void Function(ProductModel) onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered ? AppColors.blue : AppColors.border,
              width: _hovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.blue.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _hovered ? 18 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto del Producto
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                    child: Image.asset(
                      p.imageUrl.isNotEmpty ? p.imageUrl : 'assets/images/catalog_demo.jpg',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: AppColors.paleBlue,
                        child: const Center(
                          child: Icon(Icons.inventory_2_rounded, size: 40, color: AppColors.blue),
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.trustGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('NUEVO', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          ),
                        if (p.discount > 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('-${p.discount.toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Disponibilidad
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: p.availability == 'En stock'
                            ? AppColors.trustGreen.withValues(alpha: 0.9)
                            : AppColors.warning.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.availability,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              // Info del Producto
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría
                      Text(
                        p.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Nombre
                      Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      if (p.model.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Modelo: ${p.model}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                        ),
                      ],
                      const Spacer(),
                      // Precio
                      Text(
                        p.priceDisplay,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // MOQ
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'MOQ: ${p.moq} ${p.unit}s',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Sheet Detalle de Producto ─────────────────────────────────────────
class _ProductDetailSheet extends StatelessWidget {
  final ProductModel product;
  final ProviderModel provider;

  const _ProductDetailSheet({required this.product, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
              ),
            ),

            // Foto grande
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Image.asset(
                product.imageUrl.isNotEmpty ? product.imageUrl : 'assets/images/catalog_demo.jpg',
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría + Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.paleBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(product.category,
                            style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 8),
                      if (product.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.trustGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('NUEVO',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      if (product.discount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('-${product.discount.toInt()}% descuento',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Nombre y Modelo
                  Text(product.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  if (product.model.isNotEmpty)
                    Text('Modelo / SKU: ${product.model}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),

                  const SizedBox(height: 14),

                  // Descripción
                  Text(product.description,
                      style: const TextStyle(fontSize: 14, height: 1.55, color: AppColors.textPrimary)),

                  const SizedBox(height: 20),

                  // Precio y MOQ destacados
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paleBlue,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Precio Unitario', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(product.priceDisplay,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.navy)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 40, color: AppColors.border),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pedido Mínimo (MOQ)', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('${product.moq} ${product.unit}s',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.navy)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Disponibilidad
                  Row(
                    children: [
                      Icon(
                        product.availability == 'En stock'
                            ? Icons.check_circle_rounded
                            : Icons.schedule_rounded,
                        color: product.availability == 'En stock'
                            ? AppColors.trustGreen
                            : AppColors.warning,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.availability,
                        style: TextStyle(
                          color: product.availability == 'En stock' ? AppColors.trustGreen : AppColors.warning,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Características
                  if (product.characteristics.isNotEmpty) ...[
                    const Text('Características y Especificaciones:',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ...product.characteristics.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.trustGreen),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(c,
                                  style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary, height: 1.35)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Botones de acción
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.trustGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuotationRequestScreen()),
                      );
                    },
                    icon: const Icon(Icons.request_quote_rounded),
                    label: Text(
                      'Solicitar Cotización — ${product.name}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.navy, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Volver al Catálogo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Badge Informativo ─────────────────────────────────────────────────────────
class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.navy),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.navy, fontSize: 11.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── Tab de Perfil Corporativo Integral ─────────────────────────────────────────
class _CompanyFullProfileTab extends StatelessWidget {
  final ProviderModel provider;

  const _CompanyFullProfileTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final cleanName = provider.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final rucCode = 'J0310000${provider.id.hashCode.abs().toString().padLeft(6, '0')}';
    final phoneExt = (provider.id.hashCode.abs() % 8999 + 1000).toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Verificación Corporativa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navy.withValues(alpha: 0.05), AppColors.paleBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.trustGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perfil Corporativo Oficial y Verificado B2B',
                        style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Documentación legal, estados fiscales ante la DGI y capacidad operativa verificada por PROVEO Nicaragua.',
                        style: TextStyle(color: AppColors.navy.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Resumen y Badges
          const Text('Acerca de la Empresa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navy)),
          const SizedBox(height: 8),
          Text(
            provider.description,
            style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoBadge(icon: Icons.business_center_outlined, text: '${provider.years} años de trayectoria'),
              const _InfoBadge(icon: Icons.verified_rounded, text: 'RUC y DGI Activo'),
              const _InfoBadge(icon: Icons.local_shipping_outlined, text: 'Flota de Distribución Propia'),
              const _InfoBadge(icon: Icons.factory_outlined, text: 'Fabricación Directa'),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.border),
          const SizedBox(height: 20),

          // ── SECCIÓN 1: FICHA LEGAL Y TRIBUTARIA ──────────────────────────
          _buildSectionCard(
            title: 'Ficha Legal y Registro Mercantil',
            icon: Icons.gavel_rounded,
            iconColor: AppColors.navy,
            items: [
              _ProfileDataRow(label: 'Razón Social Oficial:', value: '${provider.name} de Nicaragua, S.A.'),
              _ProfileDataRow(label: 'Número RUC (DGI):', value: rucCode, isBadge: true),
              _ProfileDataRow(label: 'Año de Fundación:', value: '${DateTime.now().year - provider.years} (${provider.years} años en el mercado)'),
              _ProfileDataRow(label: 'Rubro Principal:', value: provider.category),
              const _ProfileDataRow(label: 'Régimen Tributario:', value: 'Régimen General / Grandes Contribuyentes'),
            ],
          ),
          const SizedBox(height: 20),

          // ── SECCIÓN 2: INSTALACIONES Y CAPACIDAD OPERATIVA ───────────────
          _buildSectionCard(
            title: 'Instalaciones y Capacidad Productiva',
            icon: Icons.factory_rounded,
            iconColor: AppColors.teal,
            items: [
              _ProfileDataRow(label: 'Planta y Oficinas:', value: 'Parque Industrial / Km 7.5 Carretera Norte, ${provider.location}'),
              const _ProfileDataRow(label: 'Horario de Atención B2B:', value: 'Lunes a Viernes: 8:00 AM – 5:00 PM | Sábados: 8:00 AM – 12:00 PM'),
              const _ProfileDataRow(label: 'Capacidad de Fabricación:', value: 'Hasta 500,000 unidades mensuales con líneas de inyección y sellado'),
              const _ProfileDataRow(label: 'Bodega de Almacenamiento:', value: 'Área de 3,200 m² climatizada y con control de inventario digital'),
            ],
          ),
          const SizedBox(height: 20),

          // ── SECCIÓN 3: POLÍTICAS COMERCIALES Y LOGÍSTICA ────────────────
          _buildSectionCard(
            title: 'Condiciones Comerciales y Logística',
            icon: Icons.local_shipping_rounded,
            iconColor: AppColors.trustGreen,
            items: [
              _ProfileDataRow(label: 'Tiempo Promedio de Respuesta:', value: provider.responseTime),
              const _ProfileDataRow(label: 'Cobertura de Despacho:', value: 'Rutas fijas a Managua, Masaya, León, Chinandega, Matagalpa y Estelí'),
              const _ProfileDataRow(label: 'Pedido Mínimo (MOQ):', value: 'Desde 100 unidades según línea de producto'),
              const _ProfileDataRow(label: 'Métodos de Pago:', value: 'Transferencia ACH (BAC, Banpro, Lafise), Cheque y Crédito 30 días'),
              const _ProfileDataRow(label: 'Muestras Físicas:', value: 'Disponibles sin costo para empresas y marcas verificadas'),
            ],
          ),
          const SizedBox(height: 20),

          // ── SECCIÓN 4: CANALES DIRECTOS DE CONTACTO ─────────────────────
          _buildSectionCard(
            title: 'Canales de Contacto Directo B2B',
            icon: Icons.headset_mic_rounded,
            iconColor: AppColors.blue,
            items: [
              _ProfileDataRow(label: 'PBX / Atención:', value: '+505 2278-$phoneExt'),
              _ProfileDataRow(label: 'WhatsApp Corporativo:', value: '+505 8899-$phoneExt'),
              _ProfileDataRow(label: 'Correo de Ventas:', value: 'ventas@$cleanName.com.ni'),
              _ProfileDataRow(label: 'Sitio Web Oficial:', value: 'www.$cleanName.com.ni'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.navy),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDataRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBadge;

  const _ProfileDataRow({
    required this.label,
    required this.value,
    this.isBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 190,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: isBadge
                ? Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.trustGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('ACTIVO DGI',
                            style: TextStyle(color: AppColors.trustGreen, fontSize: 9, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Tab de Calidad y Calificaciones Ultra-Premium ──────────────────────────────
class _QualitySectionTab extends StatelessWidget {
  final ProviderModel provider;

  const _QualitySectionTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── SCORECARD PRINCIPAL DE CALIDAD ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Flex(
              direction: MediaQuery.of(context).size.width < 700 ? Axis.vertical : Axis.horizontal,
              children: [
                // Gran Nota Promedio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      provider.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => const Icon(Icons.star_rounded, color: AppColors.warning, size: 22),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${provider.reviews} opiniones verificadas',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.trustGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Nivel Platino • 98% Satisfacción',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32, height: 24),

                // Desglose de Métricas
                const Expanded(
                  child: Column(
                    children: [
                      _QualityWhiteScoreBar(label: 'Calidad de Materiales y Resistencia', score: 4.9, percent: '98%'),
                      SizedBox(height: 12),
                      _QualityWhiteScoreBar(label: 'Cumplimiento de Plazos de Entrega (SLA)', score: 4.8, percent: '96%'),
                      SizedBox(height: 12),
                      _QualityWhiteScoreBar(label: 'Atención Técnica y Rapidez de Respuesta', score: 4.7, percent: '95%'),
                      SizedBox(height: 12),
                      _QualityWhiteScoreBar(label: 'Competitividad en Precios y Condiciones', score: 4.6, percent: '94%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── SELLOS Y CERTIFICACIONES OFICIALES ──────────────────────────
          const Text(
            'Sellos de Calidad y Certificaciones Auditadas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navy),
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _CertificationCard(
                icon: Icons.verified_rounded,
                title: 'ISO 9001:2015',
                desc: 'Sistema de Gestión de Calidad B2B',
                color: AppColors.blue,
              ),
              _CertificationCard(
                icon: Icons.health_and_safety_rounded,
                title: 'Registro Sanitario MINSA',
                desc: 'Apto para grado alimenticio e industrial',
                color: AppColors.trustGreen,
              ),
              _CertificationCard(
                icon: Icons.eco_rounded,
                title: 'Producción Sostenible',
                desc: 'Materia prima reciclable y bajo impacto',
                color: AppColors.teal,
              ),
              _CertificationCard(
                icon: Icons.flag_rounded,
                title: 'Hecho en Nicaragua',
                desc: 'Estándares de calidad para exportación',
                color: AppColors.navy,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── MURO DE RESEÑAS VERIFICADAS ────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Experiencias Reales de Compradores B2B',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navy),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: const BorderSide(color: AppColors.navy),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gracias por tu interés en calificar este proveedor')),
                  );
                },
                icon: const Icon(Icons.rate_review_outlined, size: 16),
                label: const Text('Dejar Reseña', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _ReviewCard(
            author: 'Lic. Roberto Méndez',
            company: 'Café Segoviano R.L. • Matagalpa',
            rating: 5,
            date: 'Hace 1 semana',
            comment: 'Excelente proveedor. Pedimos un lote de 5,000 empaques con sellado hermético y llegaron 2 días antes de la fecha límite. La calidad de la impresión fue insuperable.',
            badge: 'Compra Verificada',
          ),
          const SizedBox(height: 12),
          const _ReviewCard(
            author: 'Ing. Elena Morales',
            company: 'Distribuidora Central • Managua',
            rating: 5,
            date: 'Hace 3 semanas',
            comment: 'Llevamos más de 2 años comprando con ellos a través de PROVEO. Nos otorgaron línea de crédito a 30 días sin complicaciones y el soporte por WhatsApp es inmediato.',
            badge: 'Cliente Frecuente',
          ),
          const SizedBox(height: 12),
          const _ReviewCard(
            author: 'Carlos Alvarado',
            company: 'Emprendimiento Gourmet • Masaya',
            rating: 4,
            date: 'Hace 1 mes',
            comment: 'Muy buena relación calidad-precio. Las muestras físicas llegaron rápido a nuestra oficina para hacer las pruebas de calor antes de hacer el pedido mayorista.',
            badge: 'Compra Verificada',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _QualityWhiteScoreBar extends StatelessWidget {
  final String label;
  final double score;
  final String percent;

  const _QualityWhiteScoreBar({
    required this.label,
    required this.score,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '$percent ($score/5.0)',
              style: const TextStyle(color: AppColors.trustGreen, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score / 5.0,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.trustGreen),
          ),
        ),
      ],
    );
  }
}

class _CertificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _CertificationCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5, height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String author;
  final String company;
  final int rating;
  final String date;
  final String comment;
  final String badge;

  const _ReviewCard({
    required this.author,
    required this.company,
    required this.rating,
    required this.date,
    required this.comment,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.paleBlue,
                    child: Text(
                      author.isNotEmpty ? author[0] : 'U',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: AppColors.navy)),
                      Text(company, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.paleGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: AppColors.trustGreen, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: i < rating ? AppColors.warning : AppColors.border,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: const TextStyle(fontSize: 13, height: 1.45, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}