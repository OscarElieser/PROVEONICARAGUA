// ==============================================================================
// PROVEO NICARAGUA - Pantalla Principal / Landing B2B (lib/screens/home_screen.dart)
// ¿Qué hace?: Despliega la página de inicio con buscador interactivo, métricas de impacto, carrusel de marcas y proveedores destacados.
// ¿Por qué se utiliza?: Es la vitrina de entrada que conecta a los compradores con el motor de matching y el ecosistema empresarial de Nicaragua.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa temporizadores para el carrusel de marcas con auto-scroll
import 'dart:async';

// Importa la paleta de colores corporativa
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

// Importa los widgets reutilizables del sistema de diseño
import '../core/widgets/premium_widgets.dart';
import '../core/widgets/proveo_logo.dart';

// Importa los modelos del dominio
import '../models/models.dart';

// Importa el repositorio de base de datos Firestore
import '../services/firebase/firestore_repository.dart';

// Importa las pantallas navegables desde el Home
import 'chat_screen.dart';
import 'match_screen.dart';
import 'provider_profile_screen.dart';
import 'search_screen.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_footer.dart';
import '../core/widgets/premium_header.dart';

/// Pantalla de inicio centrada en confianza, reputación y descubrimiento de proveedores.
class HomeScreen extends StatelessWidget {
  /// Constructor constante
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder permite adaptar la densidad visual según el ancho de pantalla disponible
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint para modo escritorio (>= 1000px)
        final desktop = constraints.maxWidth >= 1000;

        final mainContent = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: desktop ? 36 : 20,
            vertical: 18,
          ),
          child: Center(
            child: ConstrainedBox(
              // Ancho máximo contenido para una lectura cómoda
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Barra de navegación superior
                  const PremiumHeader(currentPage: 'Inicio', showBackButton: false),
                  const SizedBox(height: 20),

                  // 2. Sección Hero con llamada a la acción y buscador rápido
                  _Hero(desktop: desktop),
                  const SizedBox(height: 18),

                  // 3. Franja de métricas e impacto en Nicaragua
                  const _Metrics(),
                  const SizedBox(height: 48),

                  // 4. Galería animada de marcas comerciales aliadas
                  const _BrandGallery(),
                  const SizedBox(height: 48),

                  // 5. Explicación paso a paso de cómo funciona la plataforma
                  const SectionTitle(
                    title: '¿Cómo funciona PROVEO?',
                    subtitle: 'Una forma más clara de encontrar y elegir proveedores',
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _Step(
                        number: '1',
                        icon: Icons.search,
                        title: 'Cuéntanos qué necesitas',
                        text: 'Describe el producto o servicio.',
                      ),
                      _Step(
                        number: '2',
                        icon: Icons.auto_awesome_outlined,
                        title: 'Recibe recomendaciones',
                        text: 'Encontramos opciones para ti con IA.',
                      ),
                      _Step(
                        number: '3',
                        icon: Icons.description_outlined,
                        title: 'Compara y cotiza',
                        text: 'Analiza precio, reputación y tiempos.',
                      ),
                      _Step(
                        number: '4',
                        icon: Icons.handshake_outlined,
                        title: 'Conecta y decide',
                        text: 'Elige con total respaldo comercial.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),

                  // 6. Testimonios de compradores y gerentes de compras
                  const _Testimonials(),
                  const SizedBox(height: 64),

                  // 7. Proveedores destacados con consulta en tiempo real
                  const SectionTitle(
                    title: 'Proveedores destacados',
                    subtitle: 'Empresas verificadas con reputación comprobada',
                  ),
                  const SizedBox(height: 16),
                  const _FeaturedProviders(),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        );

        // Envuelve en scroll vertical para permitir navegación completa hasta el footer
        return SingleChildScrollView(
          child: Column(
            children: [
              mainContent,
              const PremiumFooter(),
            ],
          ),
        );
      },
    );
  }
}

/// Bloque Hero principal que presenta la propuesta de valor y caja de búsqueda rápida.
class _Hero extends StatelessWidget {
  final bool desktop;
  const _Hero({required this.desktop});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.paleBlue],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Flex(
        direction: desktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: desktop ? 6 : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerifiedBadge(text: 'Red empresarial inteligente de Nicaragua'),
                const SizedBox(height: 16),
                Text(
                  'Encuentra proveedores de confianza para hacer crecer tu negocio',
                  style: AppTypography.titulo.copyWith(color: AppColors.navy),
                ),
                const SizedBox(height: 12),
                Text(
                  'PROVEO es el puente inteligente que conecta emprendedores y empresas con los mejores proveedores.',
                  style: AppTypography.subtitulo.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(
                  'Una forma más clara de elegir tus proveedores.',
                  style: AppTypography.cuerpo.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 22),
                // Formulario de búsqueda rápida
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
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
                  ],
                ),
                const SizedBox(height: 16),
                // Sellos de confianza y garantías
                const Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _Trust(icon: Icons.verified_outlined, text: 'Proveedores verificados'),
                    _Trust(icon: Icons.bolt_outlined, text: 'Cotizaciones rápidas'),
                    _Trust(icon: Icons.auto_awesome, text: 'Recomendaciones con Gemini IA'),
                    _Trust(icon: Icons.shield_outlined, text: 'Información confiable'),
                  ],
                ),
              ],
            ),
          ),
          if (desktop) const SizedBox(width: 28),
          if (desktop) const Expanded(child: _HeroVisual()),
        ],
      ),
    );
  }
}

/// Elemento visual interactivo a la derecha del Hero en pantallas desktop.
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
            // Isotipo oficial de Proveo con degradado corporativo
            const ProveoLogo.iconOnly(height: 68),
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

/// Etiqueta compacta que presenta un icono y texto de confianza comercial.
class _Trust extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Trust({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.trustGreen, size: 16),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ],
      );
}

/// Contenedor de estadísticas clave alcanzadas por la plataforma en el mercado nicaragüense.
class _Metrics extends StatelessWidget {
  const _Metrics();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
        child: const Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 18,
          children: [
            _Metric(value: '1,250+', label: 'Proveedores registrados', icon: Icons.people_alt_outlined),
            _Metric(value: '4,800+', label: 'Cotizaciones realizadas', icon: Icons.receipt_long_outlined),
            _Metric(value: '2,300+', label: 'Empresas conectadas', icon: Icons.hub_outlined),
            _Metric(value: '98%', label: 'Satisfacción de usuarios', icon: Icons.verified_outlined),
          ],
        ),
      );
}

/// Tarjeta individual de métrica cuantitativa con icono verde.
class _Metric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _Metric({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 190,
        child: Row(
          children: [
            Icon(icon, color: AppColors.successGreen, size: 30),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
      );
}

/// Tarjeta explicativa de cada paso de uso de Proveo.
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

/// Muestra los proveedores verificados destacados consultando [FirestoreRepository].
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
                        child: Text(
                          provider.name.substring(0, 1),
                          style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      const Icon(Icons.favorite_border, color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const VerifiedBadge(),
                  const SizedBox(height: 10),
                  Text(
                    provider.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  RatingStars(rating: provider.rating),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProviderProfileScreen(provider: provider),
                        ),
                      ),
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

/// Galería de logotipos de empresas y marcas con desplazamiento automático horizontal continuo.
class _BrandGallery extends StatefulWidget {
  const _BrandGallery();
  @override
  State<_BrandGallery> createState() => _BrandGalleryState();
}

class _BrandGalleryState extends State<_BrandGallery> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  final List<Map<String, dynamic>> _brands = [
    {'name': 'PlastiPack', 'icon': Icons.local_shipping_outlined},
    {'name': 'LogisNica', 'icon': Icons.map_outlined},
    {'name': 'AgroTech', 'icon': Icons.eco_outlined},
    {'name': 'CacaoNica', 'icon': Icons.coffee_outlined},
    {'name': 'Empaques SA', 'icon': Icons.inventory_2_outlined},
    {'name': 'Distribuidora', 'icon': Icons.storefront_outlined},
    {'name': 'TechSolutions', 'icon': Icons.computer_outlined},
  ];

  @override
  void initState() {
    super.initState();
    // Inicia el desplazamiento suave una vez montado el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 2.0;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + delta);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Marcas que confían y se promocionan con nosotros',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 1000, // Ciclo infinito simulado
            itemBuilder: (context, index) {
              final brand = _brands[index % _brands.length];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(brand['icon'] as IconData, color: AppColors.navy.withValues(alpha: 0.5), size: 28),
                    const SizedBox(width: 10),
                    Text(
                      brand['name'] as String,
                      style: TextStyle(
                        color: AppColors.navy.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Sección que agrupa tarjetas de testimonios reales de clientes y directores de compras.
class _Testimonials extends StatelessWidget {
  const _Testimonials();

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          title: 'Lo que dicen nuestros usuarios',
          subtitle: 'Experiencias reales construyendo negocios con PROVEO',
        ),
        const SizedBox(height: 24),
        Flex(
          direction: desktop ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: _TestimonialCard(
                quote:
                    "PROVEO revolucionó nuestras compras. Encontrar empaques de calidad nos tomaba semanas, ahora con IA Match conseguimos 3 cotizaciones en 2 horas.",
                author: "Carlos Méndez",
                role: "Emprendedor, Café Nica",
                rating: 5,
              ),
            ),
            SizedBox(width: 24, height: 24),
            Expanded(
              child: _TestimonialCard(
                quote:
                    "Como proveedores, hemos aumentado nuestras ventas corporativas en un 40%. La plataforma nos conecta con clientes que buscan exactamente lo que ofrecemos.",
                author: "Laura Castillo",
                role: "Gerente, PlastiPack",
                rating: 5,
              ),
            ),
            SizedBox(width: 24, height: 24),
            Expanded(
              child: _TestimonialCard(
                quote:
                    "La verificación de empresas nos da mucha paz mental. Saber que estás negociando con entidades registradas y evaluadas no tiene precio.",
                author: "Roberto Silva",
                role: "Director de Compras, Distribuidora RS",
                rating: 4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Tarjeta individual con la cita textual del testimonio, estrellas de satisfacción y autor.
class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final String role;
  final int rating;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    required this.role,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                color: index < rating ? AppColors.warning : AppColors.border,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"$quote"',
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.paleBlue,
                child: Text(
                  author[0],
                  style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy, fontSize: 13),
                    ),
                    Text(
                      role,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

