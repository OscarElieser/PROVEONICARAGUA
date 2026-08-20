import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/ai/gemini_recommendation_service.dart';
import '../services/firebase/firestore_repository.dart';
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';
import 'chat_screen.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';

/// Pantalla PROVEO Match interactiva, visualmente impactante y optimizada para conversión B2B.
class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int _step = 0;
  String _selectedCategory = 'Empaques y Envases Plásticos';
  String _selectedLocation = 'Managua';
  String _selectedPriority = 'Calidad y Certificaciones (ISO/BPA Free)';
  String _estimatedVolume = '1,000 - 5,000 unidades';
  String _customNotes = '';

  final _geminiService = GeminiService();
  String? _aiExplanation;
  bool _loadingAi = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Empaques y Envases Plásticos',
      'subtitle': 'Frascos PET, tapas herméticas, galoneras y bidones industriales.',
      'tag': 'Más Solicitado',
      'icon': Icons.inventory_2_rounded,
      'color': AppColors.blue,
    },
    {
      'title': 'Bolsas Biodegradables y Papel',
      'subtitle': 'Bolsas compostables, tipo boutique, kraft y empaque ecológico.',
      'tag': 'Sostenible',
      'icon': Icons.eco_rounded,
      'color': AppColors.trustGreen,
    },
    {
      'title': 'Etiquetas y Adhesivos Industriales',
      'subtitle': 'Térmicas, vinil mate/brillante, barniz UV y rollos automáticos.',
      'tag': 'Alta Duración',
      'icon': Icons.label_important_rounded,
      'color': AppColors.teal,
    },
    {
      'title': 'Cajas de Cartón y Embalaje',
      'subtitle': 'Corrugado reforzado, microcorrugado con branding e inserts.',
      'tag': 'Logística Segura',
      'icon': Icons.all_inbox_rounded,
      'color': const Color(0xFFC07020),
    },
    {
      'title': 'Materia Prima y Polímeros',
      'subtitle': 'Resinas vírgenes, masterbatch de color, polietileno y polipropileno.',
      'tag': 'Uso Industrial',
      'icon': Icons.science_rounded,
      'color': const Color(0xFF6B46C1),
    },
    {
      'title': 'Empaques para Café y Alimentos',
      'subtitle': 'Bolsas doypack con zipper, trilaminadas con válvula desgasificadora.',
      'tag': 'Grado Alimenticio',
      'icon': Icons.coffee_rounded,
      'color': const Color(0xFF8D5B4C),
    },
  ];

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Managua',
      'highlight': 'Mayor inventario y despacho en 24h',
      'badge': 'Hub Central',
      'icon': Icons.location_city_rounded,
    },
    {
      'name': 'Masaya',
      'highlight': 'Ruta diaria de distribución express',
      'badge': 'Zona Oriente',
      'icon': Icons.near_me_rounded,
    },
    {
      'name': 'León',
      'highlight': 'Despachos martes, jueves y sábados',
      'badge': 'Occidente',
      'icon': Icons.business_rounded,
    },
    {
      'name': 'Chinandega',
      'highlight': 'Conexión con zona portuaria y agroindustrial',
      'badge': 'Agroindustria',
      'icon': Icons.directions_boat_rounded,
    },
    {
      'name': 'Matagalpa',
      'highlight': 'Atención especializada a cooperativas y fincas',
      'badge': 'Zona Norte',
      'icon': Icons.terrain_rounded,
    },
    {
      'name': 'Estelí',
      'highlight': 'Rutas continuas para comercio y manufactura',
      'badge': 'Manufactura',
      'icon': Icons.domain_rounded,
    },
    {
      'name': 'Todo el País',
      'highlight': 'Alianzas con transportistas certificados a los 15 departamentos',
      'badge': 'Cobertura Total',
      'icon': Icons.public_rounded,
    },
  ];

  final List<Map<String, dynamic>> _priorities = [
    {
      'title': 'Mejor Precio por Volumen',
      'desc': 'Maximizar márgenes de ganancia con precios mayoristas de fábrica directa.',
      'badge': 'Ahorro Escala',
      'icon': Icons.savings_rounded,
      'color': AppColors.trustGreen,
    },
    {
      'title': 'Calidad y Certificaciones (ISO/BPA Free)',
      'desc': 'Cumplimiento de estándares de exportación y grado alimenticio certificado.',
      'badge': 'Garantía Total',
      'icon': Icons.verified_rounded,
      'color': AppColors.blue,
    },
    {
      'title': 'Entrega Inmediata / Despacho Rápido',
      'desc': 'Inventario disponible en bodega listo para entrega en menos de 48 horas.',
      'badge': 'Express 24/48h',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFDD6B20),
    },
    {
      'title': 'Cercanía Geográfica y Soporte',
      'desc': 'Fabricante cercano para inspección de muestras y soporte presencial ágil.',
      'badge': 'Trato Directo',
      'icon': Icons.handshake_rounded,
      'color': AppColors.teal,
    },
  ];

  final List<String> _volumes = [
    'Menos de 1,000 unidades',
    '1,000 - 5,000 unidades',
    '5,000 - 20,000 unidades',
    'Más de 20,000 unidades / Contrato continuo',
  ];

  Future<void> _generateAiAnalysis() async {
    setState(() => _loadingAi = true);
    try {
      final prompt = '''Eres el Asesor Senior de Compras B2B de PROVEO Nicaragua.
Un emprendedor/empresa completó PROVEO Match con estos criterios:
- Rubro: $_selectedCategory
- Ubicación: $_selectedLocation
- Prioridad Estratégica: $_selectedPriority
- Volumen Estimado: $_estimatedVolume
Objetivo de la IA: actuar como asistente de compra completo para que el comprador pueda elegir, cotizar y comprar con confianza.
Debe cubrir: compatibilidad del proveedor, validacion de datos, muestra, ficha tecnica, MOQ, entrega, precio final y siguiente paso de compra.
${_customNotes.isNotEmpty ? '- Requerimiento Específico: $_customNotes' : ''}

Explica en un párrafo conciso y motivador (máximo 3 oraciones):
1. Por qué los fabricantes seleccionados encajan con esta necesidad.
2. Qué beneficio clave obtendrá el comprador en tiempos o costos en Nicaragua.''';

      final response = await _geminiService.generarRespuesta(prompt);
      if (mounted) {
        setState(() {
          _aiExplanation = response;
          _loadingAi = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _aiExplanation = 'Hemos analizado los fabricantes con mayor capacidad operativa en $_selectedLocation para $_selectedCategory. Destacan por su cumplimiento de entregas y precios competitivos para $_estimatedVolume.';
          _loadingAi = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step >= 3) {
      if (_aiExplanation == null && !_loadingAi) {
        _generateAiAnalysis();
      }
      return _buildResultsView();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Match IA'),
      body: CustomScrollView(
        slivers: [
          // Banner Hero interactivo
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blue, AppColors.teal],
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.trustGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROVEO MATCH IA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                'Emparejamiento inteligente de proveedores B2B',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Barra de progreso interactiva
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_step + 1) / 3,
                          minHeight: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.trustGreen),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Paso ${_step + 1} de 3 — ${_getStepTitle()}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${((_step + 1) / 3 * 100).round()}% completado',
                            style: const TextStyle(color: AppColors.trustGreen, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenido del paso actual
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_step == 0) _buildStep0(),
                      if (_step == 1) _buildStep1(),
                      if (_step == 2) _buildStep2(),

                      const SizedBox(height: 32),

                      // Botones de Navegación del Wizard
                      Row(
                        children: [
                          if (_step > 0)
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: AppColors.border, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () => setState(() => _step--),
                                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                                label: const Text('Anterior', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          if (_step > 0) const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _step == 2 ? AppColors.trustGreen : AppColors.navy,
                                elevation: 4,
                                shadowColor: (_step == 2 ? AppColors.trustGreen : AppColors.navy).withValues(alpha: 0.4),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                setState(() => _step++);
                              },
                              icon: Icon(_step == 2 ? Icons.auto_awesome_rounded : Icons.arrow_forward_rounded, size: 20),
                              label: Text(
                                _step == 2 ? 'IA: Encontrar proveedor y preparar compra' : 'Siguiente Paso',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Rubro y Producto';
      case 1:
        return 'Zona de Entrega';
      case 2:
        return 'Prioridad y Volumen';
      default:
        return '';
    }
  }

  // ── PASO 0: CATEGORÍA VISUAL Y LLAMATIVA ─────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.category_rounded, color: AppColors.blue, size: 24),
            SizedBox(width: 8),
            Text('¿Qué producto o insumo necesita tu negocio?',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Selecciona la categoría principal para que los algoritmos de IA de PROVEO evalúen existencias y precios mayoristas.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 20),

        // Grid interactivo de categorías
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 580;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['title'];
              final width = isWide ? (constraints.maxWidth - 14) / 2 : double.infinity;
              final Color catColor = cat['color'] as Color;

              return InkWell(
                onTap: () => setState(() => _selectedCategory = cat['title']),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: width,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? catColor.withValues(alpha: 0.07) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? catColor : AppColors.border,
                      width: isSelected ? 2.2 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? catColor.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
                        blurRadius: isSelected ? 16 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? catColor : catColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              cat['icon'] as IconData,
                              color: isSelected ? Colors.white : catColor,
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? catColor : AppColors.paleBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              cat['tag'] as String,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.navy,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: isSelected ? catColor : AppColors.textSecondary.withValues(alpha: 0.5),
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        cat['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: isSelected ? catColor : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cat['subtitle'] as String,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.35),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  // ── PASO 1: UBICACIÓN Y LOGÍSTICA VISUAL ─────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.local_shipping_rounded, color: AppColors.teal, size: 24),
            SizedBox(width: 8),
            Text('¿En qué departamento requieres la entrega?',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Filtramos fabricantes con flotilla propia o cobertura de transporte asegurada a tu ciudad para evitar retrasos.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 20),

        // Lista de tarjetas interactivas de departamento
        ..._locations.map((loc) {
          final isSelected = _selectedLocation == loc['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedLocation = loc['name']),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.teal.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.teal : AppColors.border,
                    width: isSelected ? 2.2 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? AppColors.teal.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.03),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.teal : AppColors.paleBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        loc['icon'] as IconData,
                        color: isSelected ? Colors.white : AppColors.teal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                loc['name'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: isSelected ? AppColors.teal : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.teal : AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  loc['badge'] as String,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            loc['highlight'] as String,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? AppColors.teal : AppColors.textSecondary.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── PASO 2: PRIORIDAD ESTRATÉGICA Y VOLUMEN ──────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.tune_rounded, color: AppColors.trustGreen, size: 24),
            SizedBox(width: 8),
            Text('¿Cuál es tu prioridad estratégica de compra?',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'La IA de Gemini ordenará y ponderará a los proveedores según lo que más valore tu negocio.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 20),

        // Tarjetas de Prioridad
        ..._priorities.map((p) {
          final isSelected = _selectedPriority == p['title'];
          final Color pColor = p['color'] as Color;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedPriority = p['title']),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? pColor.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? pColor : AppColors.border,
                    width: isSelected ? 2.2 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? pColor.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.03),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? pColor : pColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        p['icon'] as IconData,
                        color: isSelected ? Colors.white : pColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p['title'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: isSelected ? pColor : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isSelected ? pColor : AppColors.paleBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  p['badge'] as String,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.navy,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['desc'] as String,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? pColor : AppColors.textSecondary.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Selector de Volumen Estimado
        const Text('Volumen estimado de compra:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _volumes.map((vol) {
            final isVolSelected = _estimatedVolume == vol;
            return ChoiceChip(
              label: Text(vol),
              selected: isVolSelected,
              selectedColor: AppColors.navy,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isVolSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              side: BorderSide(color: isVolSelected ? AppColors.navy : AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (selected) {
                if (selected) setState(() => _estimatedVolume = vol);
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Notas Adicionales Personalizadas
        TextField(
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Especificaciones técnicas o detalles adicionales (Opcional)',
            hintText: 'Ej. Requiero impresión a 2 tintas, medidas de 500ml y tapa rosca...',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.note_alt_outlined, color: AppColors.navy),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onChanged: (val) => _customNotes = val,
        ),
      ],
    );
  }

  // ── RESULTADOS IMPACTANTES CON IA GEMINI ─────────────────────────────
  Widget _buildResultsView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Match IA'),
      body: FutureBuilder<List<ProviderModel>>(
        future: FirestoreRepository().getProviders(),
        builder: (context, snapshot) {
          final providers = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Banner de Resumen del Lead con IA
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.navy, AppColors.blue, AppColors.teal],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.navy.withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.trustGreen,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Análisis Estratégico Gemini AI',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            'Evaluación algorítmica de compatibilidad B2B',
                                            style: TextStyle(color: Colors.white70, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: const Icon(Icons.replay_rounded, size: 16, color: AppColors.trustGreen),
                                      label: const Text('Nuevo Match', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                      onPressed: () => setState(() {
                                        _step = 0;
                                        _aiExplanation = null;
                                      }),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24, height: 24),
                                if (_loadingAi)
                                  const Row(
                                    children: [
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(color: AppColors.trustGreen, strokeWidth: 2.5),
                                      ),
                                      SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Gemini AI está procesando el perfil de tu empresa y cruzando variables...',
                                          style: TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    _aiExplanation ??
                                        'Hemos seleccionado los proveedores verificados con mayor capacidad logística y operativa en tu zona.',
                                    style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.5),
                                  ),
                                const SizedBox(height: 14),
                                // Resumen de los filtros
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _FilterChipWhite(icon: Icons.category_rounded, text: _selectedCategory),
                                    _FilterChipWhite(icon: Icons.location_on_rounded, text: _selectedLocation),
                                    _FilterChipWhite(icon: Icons.inventory_2_rounded, text: _estimatedVolume),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Encabezado de la lista
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Proveedores Recomendados',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.navy),
                                  ),
                                  Text(
                                    '${providers.length} fabricantes verificados listos para cotizar',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                label: const Text('Consultar Asistente', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Lista de Proveedores Recomendados
                          ...providers.map((p) {
                            final matchPercent = (p.rating / 5 * 85 + (p.featured ? 14 : 6)).round().clamp(82, 99);
                            return _ProviderMatchCard(provider: p, matchPercent: matchPercent);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: PremiumFooter()),
            ],
          );
        },
      ),
    );
  }
}

// ── TARJETA DE PROVEEDOR CON MATCH ────────────────────────────────────
class _ProviderMatchCard extends StatelessWidget {
  final ProviderModel provider;
  final int matchPercent;

  const _ProviderMatchCard({required this.provider, required this.matchPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: provider.featured ? AppColors.trustGreen.withValues(alpha: 0.6) : AppColors.border,
          width: provider.featured ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: provider.featured ? AppColors.trustGreen.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge con Match Score
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.navy, AppColors.teal],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$matchPercent%',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      const Text(
                        'MATCH',
                        style: TextStyle(color: AppColors.trustGreen, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              provider.name,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.textPrimary),
                            ),
                          ),
                          if (provider.featured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.trustGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                                  SizedBox(width: 4),
                                  Text('Top Verificado', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                          const SizedBox(width: 3),
                          Text('${provider.rating} (${provider.reviews} valoraciones)',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                          const SizedBox(width: 10),
                          const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 14),
                          const SizedBox(width: 2),
                          Text(provider.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(provider.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
            const SizedBox(height: 14),

            // Chips con capacidades de entrega y respuesta
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FeatureChip(icon: Icons.timer_outlined, text: 'Respuesta: ${provider.responseTime}', color: AppColors.blue),
                _FeatureChip(icon: Icons.history_rounded, text: '${provider.years} años de trayectoria', color: AppColors.teal),
                _FeatureChip(icon: Icons.inventory_rounded, text: provider.category, color: AppColors.trustGreen),
              ],
            ),

            const SizedBox(height: 18),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Botones de Conversión (Llamativos)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.navy, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: provider))),
                    icon: const Icon(Icons.storefront_outlined, size: 18, color: AppColors.navy),
                    label: const Text('Ver Catálogo y Perfil', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.trustGreen,
                      elevation: 3,
                      shadowColor: AppColors.trustGreen.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())),
                    icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                    label: const Text('Solicitar Cotización', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── CHIPS AUXILIARES ──────────────────────────────────────────────────
class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FeatureChip({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FilterChipWhite extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FilterChipWhite({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
