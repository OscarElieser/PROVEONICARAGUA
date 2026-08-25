// ==============================================================================
// PROVEO NICARAGUA - Perfil y Catálogo Digital del Proveedor (lib/screens/provider_profile_screen.dart)
// ¿Qué hace?: Presenta la ficha corporativa de la empresa, su catálogo de productos en grid interactivo, ficha técnica en bottom sheet y métricas de calidad.
// ¿Por qué se utiliza?: Permite a los compradores auditar credenciales, explorar stock/MOQ y solicitar cotizaciones sobre productos específicos.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';
import '../core/utils/url_helper.dart';

// Importa los modelos del dominio de datos
import '../models/models.dart';

// Importa el servicio de inteligencia y auditoría de empresas
import '../services/ai/company_intelligence_service.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_footer.dart';
import '../core/widgets/premium_header.dart';

// Importa las pantallas de interacción directa
import 'chat_screen.dart';
import 'quotation_request_screen.dart';

// ── Datos demo del catálogo (se reemplazan por los datos reales del proveedor) ──
/// Genera el catálogo interactivo adaptado según el rubro o categoría de la empresa seleccionada
List<ProductModel> _buildDemoProducts(ProviderModel provider) {
  // Las fotos apuntan al asset demo; en producción se usan las URLs de Firestore (imageUrl).
  // Cada proveedor puede tener sus propias líneas y productos almacenados en la base de datos.
  final cat = provider.category.toLowerCase();

  // Catálogo enfocado en envases y empaques industriales
  if (cat.contains('plástico') || cat.contains('empaqu') || cat.contains('envase') || cat.isEmpty) {
    return [
      const ProductModel(
        id: 'p1',
        name: 'Galonera HDPE 1 Galón',
        model: 'GAL-001-HDPE',
        description:
            'Galonera industrial de polietileno de alta densidad con tapa de seguridad azul oscuro y asa integrada.',
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
        description:
            'Frasco PET cristal con tapa rosca de aluminio o plástica, ideal para alimentos, bebidas y cosméticos.',
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
        description:
            'Rollo de film stretch de polietileno lineal para paletizado de mercancía. Alta resistencia y extensión.',
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
        description:
            'Contenedor de polipropileno con tapa hermética apto para almacenamiento de alimentos, líquidos y sólidos.',
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
        description:
            'Barril hermético de polietileno azul de 200 litros con cierre de seguridad industrial para químicos y alimentos.',
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
        description:
            'Bolsa tipo stand-up kraft 100% biodegradable con cierre zip y ventana transparente. Apta para alimentos.',
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
      description:
          'Producto estrella del portafolio de ${provider.name}. Consulte al proveedor para especificaciones completas.',
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
  /// Modelo del proveedor cuyos datos se están visualizando
  final ProviderModel provider;

  /// Constructor constante
  const ProviderProfileScreen({super.key, required this.provider});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen>
    with SingleTickerProviderStateMixin {
  /// Controlador de pestañas para Catálogo, Perfil y Calidad
  late final TabController _tabController;

  /// Servicio de inteligencia corporativa y auditoría digital
  final _intelService = CompanyIntelligenceService();

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

  /// Despliega la hoja modal interactiva con la ficha técnica y fotos del producto
  void _openProductDetail(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductDetailSheet(product: product, provider: widget.provider),
    );
  }

  /// Copia texto al portapapeles y notifica al usuario con un Snackbar elegante
  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.trustGreen, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label copiado al portapapeles: $text',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Abre un enlace externo (sitio web o perfil oficial de red social) en una pestaña nueva
  Future<void> _launchExternalUrl(String rawUrl, String label) async {
    await openExternalUrl(rawUrl, onCopyFallback: _copyToClipboard, label: label);
  }

  @override
  Widget build(BuildContext context) {
    final products = _buildDemoProducts(widget.provider);
    final intel = _intelService.getCompanyIntelligence(widget.provider.name);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Proveedores'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. BANNER HERO CON LOGO, BADGES Y MÉTRICAS DE CONTACTO
          // ------------------------------------------------------------------
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
                          // Avatar circular con iniciales
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.navy,
                              child: Text(
                                widget.provider.logo,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1,
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
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (widget.provider.featured)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.trustGreen,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              'Top Verificado',
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                                            ),
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
                                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.provider.rating} (${widget.provider.reviews} opiniones)',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.white70),
                                    const SizedBox(width: 4),
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

          // ------------------------------------------------------------------
          // 2. CONTENIDO PRINCIPAL: AUDITORÍA IA, ACCIONES Y PESTAÑAS
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Banner de Auditoría Digital con IA y Redes Sociales
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.navy, AppColors.teal],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.navy.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.trustGreen.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded, color: AppColors.trustGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Auditoría Digital con IA Activa',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Verificación en Google, Facebook, Instagram, TikTok, YouTube y DGI',
                                    style: TextStyle(color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.trustGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(initialProvider: widget.provider),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.analytics_outlined, size: 16),
                              label: const Text('Ver Dossier IA', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),

                      // Botones de Acción Comercial: "Solicitar Cotización" y "Chat B2B"
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

                      // Pestañas de Navegación: Catálogo / Perfil / Calificaciones
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
                            // Encabezado de TabBar
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
                              height: 720,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // ── TAB 1: CATÁLOGO EN GRID ────────────────────
                                  _CatalogGrid(products: products, onTap: _openProductDetail),

                                  // ── TAB 2: PERFIL INTEGRAL DEL FABRICANTE ─────
                                  _buildComprehensiveProfileTab(context, intel),

                                  // ── TAB 3: CALIFICACIONES Y PUNTUACIÓN ────────
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

          // ------------------------------------------------------------------
          // 3. PIE DE PÁGINA UNIVERSAL
          // ------------------------------------------------------------------
          const SliverToBoxAdapter(child: PremiumFooter()),
        ],
      ),
    );
  }

  /// Construye la pestaña integral de perfil con dueño, teléfonos, correos, ubicación, redes y condiciones comerciales
  Widget _buildComprehensiveProfileTab(BuildContext context, CompanyIntelligenceData intel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. DESCRIPCIÓN COMERCIAL & CERTIFICACIONES ──────────────────────
          Text(
            widget.provider.description,
            style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 14),
          // Badges de Certificaciones
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: intel.certifications.map((cert) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.trustGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded, size: 14, color: AppColors.trustGreen),
                  const SizedBox(width: 6),
                  Text(
                    cert,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.navy),
                  ),
                ],
              ),
            )).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── 2. GOBERNANZA, DUEÑO & REPRESENTACIÓN LEGAL ────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.badge_rounded, color: AppColors.navy, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Gobernanza & Representación Legal',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.paleBlue, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                // Ficha del Propietario / Director
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.navy,
                      child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  intel.ownerName,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.navy),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, size: 16, color: AppColors.trustGreen),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            intel.ownerRole,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),
                // Ficha del Representante Legal
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, size: 18, color: AppColors.navy),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Representante Legal Acreditado',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            intel.legalRepresentative,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── 3. CANALES DE CONTACTO DIRECTO B2B ──────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.trustGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.contact_phone_rounded, color: AppColors.trustGreen, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Canales de Contacto Directo B2B',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              return Column(
                children: [
                  if (isWide)
                    Row(
                      children: [
                        Expanded(
                          child: _buildContactItem(
                            icon: Icons.phone_in_talk_rounded,
                            title: 'Central Telefónica (PBX)',
                            value: intel.phone,
                            actionLabel: 'Copiar PBX',
                            onAction: () => _copyToClipboard(intel.phone, 'Teléfono PBX'),
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildContactItem(
                            icon: Icons.chat_rounded,
                            title: 'WhatsApp Ventas B2B',
                            value: intel.whatsapp,
                            actionLabel: 'Copiar WhatsApp',
                            onAction: () => _copyToClipboard(intel.whatsapp, 'WhatsApp'),
                            color: const Color(0xFF25D366),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildContactItem(
                      icon: Icons.phone_in_talk_rounded,
                      title: 'Central Telefónica (PBX)',
                      value: intel.phone,
                      actionLabel: 'Copiar PBX',
                      onAction: () => _copyToClipboard(intel.phone, 'Teléfono PBX'),
                      color: AppColors.navy,
                    ),
                    const SizedBox(height: 10),
                    _buildContactItem(
                      icon: Icons.chat_rounded,
                      title: 'WhatsApp Ventas B2B',
                      value: intel.whatsapp,
                      actionLabel: 'Copiar WhatsApp',
                      onAction: () => _copyToClipboard(intel.whatsapp, 'WhatsApp'),
                      color: const Color(0xFF25D366),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _buildContactItem(
                    icon: Icons.alternate_email_rounded,
                    title: 'Correo Institucional de Ventas',
                    value: intel.email,
                    actionLabel: 'Copiar Correo',
                    onAction: () => _copyToClipboard(intel.email, 'Correo Electrónico'),
                    color: AppColors.blue,
                  ),
                  const SizedBox(height: 10),
                  // Horario de Atención
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Horario de Atención Comercial',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(intel.businessHours,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.paleGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Atención Hoy',
                              style: TextStyle(color: AppColors.trustGreen, fontSize: 10.5, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── 4. UBICACIÓN FÍSICA, MAPA INTERACTIVO & LOGÍSTICA ───────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.map_rounded, color: AppColors.blue, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Ubicación Física, Mapa & Capacidad Logística',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _LocationMapCard(
            intel: intel,
            provider: widget.provider,
            onCopy: _copyToClipboard,
            onOpenUrl: _launchExternalUrl,
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── 5. REDES SOCIALES & CANALES DIGITALES OFICIALES ─────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.public_rounded, color: Colors.purple, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Presencia en Redes Sociales & Web Oficial',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;

              final siteUrl = intel.website.startsWith('http')
                  ? intel.website
                  : 'https://${intel.website.replaceAll('https://', '').replaceAll('http://', '')}';

              final fbClean = (intel.facebook['handle'] ?? widget.provider.name)
                  .replaceAll('@', '')
                  .replaceAll(' ', '');
              final fbUrl = 'https://facebook.com/$fbClean';

              final igClean = (intel.instagram['handle'] ?? widget.provider.name)
                  .replaceAll('@', '')
                  .replaceAll(' ', '');
              final igUrl = 'https://instagram.com/$igClean';

              final ttClean = (intel.tiktok['handle'] ?? widget.provider.name)
                  .replaceAll('@', '')
                  .replaceAll(' ', '');
              final ttUrl = 'https://tiktok.com/@$ttClean';

              final ytQuery = Uri.encodeComponent(intel.youtube['handle'] ?? widget.provider.name);
              final ytUrl = 'https://youtube.com/results?search_query=$ytQuery';

              final liQuery = Uri.encodeComponent(intel.linkedin['handle'] ?? widget.provider.name);
              final liUrl = 'https://www.linkedin.com/search/results/all/?keywords=$liQuery';

              return GridView.count(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.45 : 1.22,
                children: [
                  // 1. Sitio Web Oficial
                  _buildSocialTile(
                    icon: Icons.language_rounded,
                    network: 'Sitio Web Oficial',
                    handle: intel.website,
                    metric: 'Catálogo Online',
                    color: AppColors.teal,
                    targetUrl: siteUrl,
                    onTap: () => _launchExternalUrl(siteUrl, 'Sitio Web Oficial'),
                  ),

                  // 2. Facebook Business
                  _buildSocialTile(
                    icon: Icons.facebook,
                    network: 'Facebook Business',
                    handle: intel.facebook['handle'] ?? '@${widget.provider.name.replaceAll(' ', '')}',
                    metric: intel.facebook['followers'] ?? '18.4K seguidores',
                    color: const Color(0xFF1877F2),
                    targetUrl: fbUrl,
                    onTap: () => _launchExternalUrl(fbUrl, 'Facebook Business'),
                  ),

                  // 3. Instagram Corporativo
                  _buildSocialTile(
                    icon: Icons.camera_alt_outlined,
                    network: 'Instagram Corporativo',
                    handle: intel.instagram['handle'] ?? '@${widget.provider.name.toLowerCase().replaceAll(' ', '_')}',
                    metric: intel.instagram['followers'] ?? '12.8K seguidores',
                    color: const Color(0xFFE1306C),
                    targetUrl: igUrl,
                    onTap: () => _launchExternalUrl(igUrl, 'Instagram Corporativo'),
                  ),

                  // 4. TikTok Business
                  _buildSocialTile(
                    icon: Icons.music_note_rounded,
                    network: 'TikTok Business',
                    handle: intel.tiktok['handle'] ?? '@${widget.provider.name.toLowerCase().replaceAll(' ', '.')}',
                    metric: intel.tiktok['followers'] ?? '24.5K seguidores',
                    color: const Color(0xFF010101),
                    targetUrl: ttUrl,
                    onTap: () => _launchExternalUrl(ttUrl, 'TikTok Business'),
                  ),

                  // 5. YouTube Oficial
                  _buildSocialTile(
                    icon: Icons.play_circle_fill_rounded,
                    network: 'YouTube Channel',
                    handle: intel.youtube['handle'] ?? '${widget.provider.name} Oficial',
                    metric: intel.youtube['followers'] ?? '3.2K suscriptores',
                    color: const Color(0xFFFF0000),
                    targetUrl: ytUrl,
                    onTap: () => _launchExternalUrl(ytUrl, 'YouTube Channel'),
                  ),

                  // 6. LinkedIn Corporativo B2B
                  _buildSocialTile(
                    icon: Icons.business_center_rounded,
                    network: 'LinkedIn B2B',
                    handle: intel.linkedin['handle'] ?? widget.provider.name,
                    metric: intel.linkedin['followers'] ?? '5.4K seguidores',
                    color: const Color(0xFF0A66C2),
                    targetUrl: liUrl,
                    onTap: () => _launchExternalUrl(liUrl, 'LinkedIn B2B'),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── 6. CAPACIDAD INDUSTRIAL & CONDICIONES COMERCIALES ──────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.warning, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Capacidad Industrial & Condiciones Comerciales',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.paleBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommercialRow(
                  icon: Icons.precision_manufacturing_rounded,
                  title: 'Capacidad de Producción Mensual',
                  value: intel.monthlyCapacity,
                ),
                const SizedBox(height: 12),
                _buildCommercialRow(
                  icon: Icons.credit_score_rounded,
                  title: 'Términos de Crédito B2B',
                  value: intel.creditTerms,
                ),
                const SizedBox(height: 12),
                _buildCommercialRow(
                  icon: Icons.payments_outlined,
                  title: 'Bancos y Medios de Pago',
                  value: intel.paymentMethods,
                ),
                const SizedBox(height: 12),
                _buildCommercialRow(
                  icon: Icons.receipt_long_rounded,
                  title: 'Registro Único de Contribuyente (RUC) & DGI',
                  value: '${intel.ruc} • ${intel.fiscalStatus}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Tarjeta de contacto con valor y botón de acción directa
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required String actionLabel,
    required VoidCallback onAction,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.navy)),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(60, 32),
              side: BorderSide(color: color.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onAction,
            child: Text(actionLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  /// Mosaico individual para cada red social con métrica, botón de redirección oficial y acción directa
  Widget _buildSocialTile({
    required IconData icon,
    required String network,
    required String handle,
    required String metric,
    required Color color,
    required String targetUrl,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: color.withValues(alpha: 0.15),
          hoverColor: color.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Fila Superior: Icono de la Red + Badge de Métricas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        metric,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Centro: Nombre Oficial de la Red y Handle / Usuario
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: AppColors.navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      handle,
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Fila Inferior: Botón de acción con enlace externo directo
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.paleBlue,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Visitar Página Oficial',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.open_in_new_rounded, size: 13, color: color),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Fila de detalle comercial con icono y descripción
  Widget _buildCommercialRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.navy, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Grid de Catálogo ─────────────────────────────────────────────────────────
/// Cuadrícula responsiva que organiza y renderiza los productos del proveedor en tarjetas.
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
/// Tarjeta individual de producto con hover animado, badges de descuento, imagen y MOQ.
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
              // Foto del Producto con badges
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
                  // Badges de "NUEVO" o porcentaje de descuento
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
                            child: const Text(
                              'NUEVO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        if (p.discount > 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${p.discount.toInt()}%',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Indicador de disponibilidad en almacén
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

              // Información comercial del Producto (Categoría, Nombre, Precio, MOQ)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text(
                        p.priceDisplay,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 4),
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
/// Modal deslizable que expone la ficha técnica completa, características de manufactura y botón de cotización.
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
            // Asa superior de deslizamiento
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
              ),
            ),

            // Foto ampliada
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
                        child: Text(
                          product.category,
                          style: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (product.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.trustGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'NUEVO',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      if (product.discount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '-${product.discount.toInt()}% descuento',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Nombre y Modelo / SKU
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  if (product.model.isNotEmpty)
                    Text(
                      'Modelo / SKU: ${product.model}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),

                  const SizedBox(height: 14),

                  // Descripción detallada
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14, height: 1.55, color: AppColors.textPrimary),
                  ),

                  const SizedBox(height: 20),

                  // Tarjeta con Precio Unitario y Pedido Mínimo (MOQ)
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
                              Text(
                                product.priceDisplay,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.navy),
                              ),
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
                              Text(
                                '${product.moq} ${product.unit}s',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.navy),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Indicador de disponibilidad
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

                  // Lista de Características y Especificaciones Técnicas
                  if (product.characteristics.isNotEmpty) ...[
                    const Text(
                      'Características y Especificaciones:',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary),
                    ),
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
                              child: Text(
                                c,
                                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Botones de acción: Solicitar Cotización o Volver
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
/// Barra de progreso lineal para desplegar el puntaje en rubros específicos de calidad.
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
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
              ),
            ),
            Text(
              '$score / 5.0',
              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.trustGreen, fontSize: 13),
            ),
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
/// Etiqueta compacta con icono para destacar atributos institucionales de la empresa.
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

// ── Tarjeta de Mapa de Ubicación & Logística GPS ──────────────────────────────
/// Componente interactivo que despliega el mapa cartográfico estilizado de Nicaragua,
/// controles de satélite/calles, zoom, marcador pulsante y accesos directos a Google Maps y Waze.
class _LocationMapCard extends StatefulWidget {
  final CompanyIntelligenceData intel;
  final ProviderModel provider;
  final void Function(String, String) onCopy;
  final Future<void> Function(String, String)? onOpenUrl;

  const _LocationMapCard({
    required this.intel,
    required this.provider,
    required this.onCopy,
    this.onOpenUrl,
  });

  @override
  State<_LocationMapCard> createState() => _LocationMapCardState();
}

class _LocationMapCardState extends State<_LocationMapCard> with SingleTickerProviderStateMixin {
  /// Modo satélite o mapa de calles
  bool _isSatellite = false;

  /// Nivel de zoom interactivo (1.0 = normal, 1.3 = medio, 1.6 = cercano)
  double _zoom = 1.0;

  /// Controlador de animación para el pulso del pin en el mapa
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      if (_zoom < 1.6) _zoom += 0.3;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoom > 0.8) _zoom -= 0.3;
    });
  }

  void _resetZoom() {
    setState(() {
      _zoom = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final intel = widget.intel;
    final isSatellite = _isSatellite;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. VENTANA CARTOGRÁFICA INTERACTIVA ───────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  // Lienzo del mapa personalizado con cuadrícula vial
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, 250),
                        painter: _MapCanvasPainter(
                          isSatellite: isSatellite,
                          zoom: _zoom,
                          pulseValue: _pulseAnimation.value,
                          providerName: widget.provider.name,
                          locationLabel: widget.provider.location,
                        ),
                      );
                    },
                  ),

                  // Pin central con logotipo e insignia
                  Center(
                    child: Transform.scale(
                      scale: _zoom,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tooltip informativo sobre el marcador
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.factory_rounded, color: AppColors.trustGreen, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  widget.provider.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Marcador de Pin con efecto pulsante
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Onda exterior
                                  Container(
                                    width: 44 * _pulseAnimation.value,
                                    height: 44 * _pulseAnimation.value,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blue.withValues(alpha: 0.25 / _pulseAnimation.value),
                                    ),
                                  ),
                                  // Pin central
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.navy,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.35),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.provider.logo,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Controles superiores: Modo Satélite & Tráfico en vivo ───
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.traffic_rounded, color: AppColors.trustGreen, size: 14),
                          SizedBox(width: 5),
                          Text(
                            'Tráfico en Vivo: Fluido',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botones de Zoom y Modo en la esquina superior derecha
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Column(
                      children: [
                        // Toggle Satélite / Calles
                        InkWell(
                          onTap: () => setState(() => _isSatellite = !_isSatellite),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                              ],
                            ),
                            child: Icon(
                              _isSatellite ? Icons.map_outlined : Icons.satellite_alt_rounded,
                              size: 18,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Botón Zoom In (+)
                        InkWell(
                          onTap: _zoomIn,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                              ],
                            ),
                            child: const Icon(Icons.add, size: 18, color: AppColors.navy),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Botón Zoom Out (-)
                        InkWell(
                          onTap: _zoomOut,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                              ],
                            ),
                            child: const Icon(Icons.remove, size: 18, color: AppColors.navy),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Botón Centrar Pin
                        InkWell(
                          onTap: _resetZoom,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4),
                              ],
                            ),
                            child: const Icon(Icons.my_location_rounded, size: 18, color: AppColors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tag inferior con Coordenadas GPS
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.gps_fixed_rounded, color: Colors.white70, size: 12),
                          const SizedBox(width: 5),
                          Text(
                            intel.coordinates,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
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

          // ── 2. DETALLE DE DIRECCIÓN Y REFERENCIAS LOGÍSTICAS ──────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dirección y botón de copiar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.pin_drop_rounded, color: AppColors.error, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dirección Exacta de Planta / Bodega Principal',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            intel.fullAddress,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copiar Dirección',
                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.navy),
                      onPressed: () => widget.onCopy(intel.fullAddress, 'Dirección física'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Punto de referencia para camiones y visitas
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.explore_outlined, color: AppColors.navy, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Punto de Referencia: ${intel.landmarkReference}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Instalaciones y Flota de Reparto
                Row(
                  children: [
                    const Icon(Icons.factory_outlined, color: AppColors.navy, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Instalaciones: ${intel.facilities}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, color: AppColors.trustGreen, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Distribución: ${intel.fleet}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── 3. BOTONES DE ACCIÓN: GOOGLE MAPS, WAZE Y COORDENADAS ────
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Botón 1: Google Maps
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          final mapsUrl = intel.googleMapsUrl.isNotEmpty
                              ? intel.googleMapsUrl
                              : 'https://maps.google.com/?q=${Uri.encodeComponent("${intel.providerName}, ${intel.location}")}';
                          if (widget.onOpenUrl != null) {
                            widget.onOpenUrl!(mapsUrl, 'Google Maps');
                          } else {
                            widget.onCopy(mapsUrl, 'Enlace Google Maps');
                          }
                        },
                        icon: const Icon(Icons.map_rounded, size: 17),
                        label: const Text(
                          'Abrir en Google Maps',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                        ),
                      ),
                    ),

                    // Botón 2: Waze
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.blue,
                          side: const BorderSide(color: AppColors.blue, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppColors.blue.withValues(alpha: 0.04),
                        ),
                        onPressed: () {
                          final cleanCoords = intel.coordinates
                              .replaceAll('° N', '')
                              .replaceAll('° W', '')
                              .replaceAll(' ', '');
                          final wazeUrl = 'https://waze.com/ul?ll=$cleanCoords&navigate=yes';
                          if (widget.onOpenUrl != null) {
                            widget.onOpenUrl!(wazeUrl, 'Waze');
                          } else {
                            widget.onCopy(wazeUrl, 'Enlace Waze');
                          }
                        },
                        icon: const Icon(Icons.directions_car_filled_rounded, size: 17),
                        label: const Text(
                          'Navegar en Waze',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                        ),
                      ),
                    ),

                    // Botón 3: Copiar Coordenadas GPS
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          widget.onCopy(intel.coordinates, 'Coordenadas GPS (${intel.coordinates})');
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.textSecondary),
                        label: const Text(
                          'Copiar GPS',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pintor del Mapa Cartográfico Vectorial ────────────────────────────────────
/// Dibuja la cuadrícula de carreteras, autopistas (Carretera Norte / Panamericana),
/// zonas industriales, curvas topográficas y etiquetas de calles de Nicaragua.
class _MapCanvasPainter extends CustomPainter {
  final bool isSatellite;
  final double zoom;
  final double pulseValue;
  final String providerName;
  final String locationLabel;

  _MapCanvasPainter({
    required this.isSatellite,
    required this.zoom,
    required this.pulseValue,
    required this.providerName,
    required this.locationLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Color de Fondo según el modo
    final bgPaint = Paint()
      ..color = isSatellite ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Bloques de Zonas Industriales y Parques Verdes
    final zonePaint = Paint()
      ..color = isSatellite
          ? const Color(0xFF0F172A).withValues(alpha: 0.7)
          : const Color(0xFFCBD5E1).withValues(alpha: 0.6);

    final greenPaint = Paint()
      ..color = isSatellite
          ? const Color(0xFF064E3B).withValues(alpha: 0.5)
          : const Color(0xFFD1FAE5).withValues(alpha: 0.7);

    // Dibuja bloques de cuadrícula urbana
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, 20, size.width * 0.35, 80),
        const Radius.circular(8),
      ),
      zonePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, 30, size.width * 0.4, 75),
        const Radius.circular(8),
      ),
      zonePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, 140, size.width * 0.3, 85),
        const Radius.circular(8),
      ),
      greenPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, 145, size.width * 0.38, 80),
        const Radius.circular(8),
      ),
      zonePaint,
    );

    // 3. Carreteras Principales y Arterias (Carretera Norte)
    final mainRoadPaint = Paint()
      ..color = isSatellite ? const Color(0xFF64748B) : Colors.white
      ..strokeWidth = 14 * zoom
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = isSatellite ? const Color(0xFF334155) : const Color(0xFF94A3B8)
      ..strokeWidth = 16 * zoom
      ..style = PaintingStyle.stroke;

    // Ruta Principal horizontal (Carretera Norte / NIC-1)
    final mainRoadPath = Path();
    mainRoadPath.moveTo(0, size.height * 0.48);
    mainRoadPath.cubicTo(
      size.width * 0.3,
      size.height * 0.46,
      size.width * 0.7,
      size.height * 0.52,
      size.width,
      size.height * 0.48,
    );

    canvas.drawPath(mainRoadPath, roadBorderPaint);
    canvas.drawPath(mainRoadPath, mainRoadPaint);

    // 4. Avenida Transversal / Acceso a Zona Franca
    final crossRoadPaint = Paint()
      ..color = isSatellite ? const Color(0xFF475569) : Colors.white
      ..strokeWidth = 10 * zoom
      ..style = PaintingStyle.stroke;

    final crossPath = Path();
    crossPath.moveTo(size.width * 0.5, 0);
    crossPath.lineTo(size.width * 0.5, size.height);
    canvas.drawPath(crossPath, crossRoadPaint);

    // 5. Etiquetas de Vías Viales
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Etiqueta: Carretera Norte (NIC-1)
    textPainter.text = TextSpan(
      text: 'Carretera Norte • NIC-1',
      style: TextStyle(
        fontSize: 10 * zoom,
        fontWeight: FontWeight.w900,
        color: isSatellite ? Colors.white70 : const Color(0xFF475569),
        letterSpacing: 0.5,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.12, size.height * 0.48 - 18));

    // Etiqueta: Acceso Zona Franca Industrial
    textPainter.text = TextSpan(
      text: 'Acceso Parque Industrial',
      style: TextStyle(
        fontSize: 9 * zoom,
        fontWeight: FontWeight.w700,
        color: isSatellite ? Colors.white60 : const Color(0xFF64748B),
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.53, size.height * 0.25));
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.isSatellite != isSatellite ||
        oldDelegate.zoom != zoom ||
        oldDelegate.pulseValue != pulseValue;
  }
}