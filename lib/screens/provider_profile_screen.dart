import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../core/widgets/premium_footer.dart';
import '../core/widgets/premium_header.dart';
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
      appBar: const PremiumHeader(currentPage: 'Proveedores'),
      body: CustomScrollView(
        slivers: [
          // ── Banner Hero ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              height: 200,
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
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                                MaterialPageRoute(builder: (_) => const ChatScreen()),
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
                              height: 560,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // ── TAB 1: CATÁLOGO EN GRID ────────────────────
                                  _CatalogGrid(products: products, onTap: _openProductDetail),

                                  // ── TAB 2: PERFIL DEL FABRICANTE ──────────────
                                  SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.provider.description,
                                          style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
                                        ),
                                        const SizedBox(height: 18),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _InfoBadge(icon: Icons.business_center_outlined, text: '${widget.provider.years} años de experiencia'),
                                            const _InfoBadge(icon: Icons.verified_user_outlined, text: 'RUC y DGI Verificado'),
                                            const _InfoBadge(icon: Icons.local_shipping_outlined, text: 'Flotilla propia de reparto'),
                                            const _InfoBadge(icon: Icons.inventory_2_outlined, text: 'Venta Mayorista y Menudeo'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ── TAB 3: CALIFICACIONES ─────────────────────
                                  const SingleChildScrollView(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        _ScoreBar(label: 'Calidad y Especificaciones de Material', score: 4.9),
                                        SizedBox(height: 14),
                                        _ScoreBar(label: 'Cumplimiento de Fechas de Entrega', score: 4.8),
                                        SizedBox(height: 14),
                                        _ScoreBar(label: 'Capacidad de Respuesta y Atención', score: 4.7),
                                        SizedBox(height: 14),
                                        _ScoreBar(label: 'Competitividad en Precios y Crédito', score: 4.6),
                                      ],
                                    ),
                                  ),
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

// ── Barra de Calificación ─────────────────────────────────────────────────────
class _ScoreBar extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreBar({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
            ),
            Text('$score / 5.0',
                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.trustGreen, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score / 5.0,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.trustGreen),
          ),
        ),
      ],
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