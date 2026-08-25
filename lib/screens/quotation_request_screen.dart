// ==============================================================================
// PROVEO NICARAGUA - Asistente Wizard de Cotización B2B (lib/screens/quotation_request_screen.dart)
// ¿Qué hace?: Guía al comprador paso a paso (Especificaciones -> Selección de Proveedores -> Confirmación/Inteligencia Empresarial) para emitir solicitudes formales.
// ¿Por qué se utiliza?: Estandariza los requerimientos de compras e integra IA para validar fuentes y reputación de los fabricantes.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa el gestor de apertura de enlaces externos
import 'package:url_launcher/url_launcher.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa los modelos de datos
import '../models/models.dart';

// Importa el servicio de inteligencia y verificación de empresas
import '../services/ai/company_intelligence_service.dart';

// Importa el repositorio de base de datos Firestore
import '../services/firebase/firestore_repository.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Flujo de Solicitud de Cotización B2B Ultra-Premium con navegación paso a paso (Anterior y Siguiente).
class QuotationRequestScreen extends StatefulWidget {
  /// Constructor constante
  const QuotationRequestScreen({super.key});

  @override
  State<QuotationRequestScreen> createState() => _QuotationRequestScreenState();
}

class _QuotationRequestScreenState extends State<QuotationRequestScreen> {
  /// Índice del paso actual en el wizard (0: Especificaciones, 1: Proveedores, 2: Confirmación)
  int step = 0;

  /// Servicio de IA para recopilar inteligencia comercial de los proveedores
  final _companyAi = CompanyIntelligenceService();

  /// Caché de reportes generados para evitar reconsultas innecesarias por proveedor
  final Map<String, Future<CompanyIntelligenceReport>> _companyReports = {};

  // --------------------------------------------------------------------------
  // Controladores de texto del formulario de especificaciones
  // --------------------------------------------------------------------------
  final _productCtrl = TextEditingController(text: 'Empaque plástico termoformado y galoneras');
  final _descCtrl = TextEditingController(
      text: 'Requerimos suministro continuo de envases plásticos grado alimenticio para distribución nacional.');
  final _quantityCtrl = TextEditingController(text: '2,500 unidades');
  final _budgetCtrl = TextEditingController(text: 'C\$ 15,000');
  final _locationCtrl = TextEditingController(text: 'Managua, Carretera Norte');

  /// Requisitos técnicos especiales disponibles para selección rápida
  final List<String> _features = [
    'Apto para alimentos (BPA Free)',
    'Con tapa de seguridad',
    'Transparente cristal',
    'Impresión serigráfica',
    'Resistente a químicos',
    'Entrega programada',
  ];

  /// Conjunto de características seleccionadas por el comprador
  final Set<String> _selectedFeatures = {'Apto para alimentos (BPA Free)', 'Con tapa de seguridad'};

  /// Proveedores candidatos disponibles para recibir la solicitud
  final List<Map<String, dynamic>> _providers = [
    {
      'name': 'PlastiPack Nicaragua',
      'location': 'Managua',
      'rating': 4.8,
      'response': '2 horas',
      'tag': 'Top Verificado',
      'selected': true,
    },
    {
      'name': 'Evanplast S.A.',
      'location': 'Masaya',
      'rating': 4.6,
      'response': '3 horas',
      'tag': 'Mejor Precio',
      'selected': true,
    },
    {
      'name': 'Innoplast',
      'location': 'León',
      'rating': 4.5,
      'response': '4 horas',
      'tag': 'Despacho Rápido',
      'selected': true,
    },
  ];

  /// Obtiene o genera el reporte de inteligencia de IA para la empresa candidata
  Future<CompanyIntelligenceReport> _reportFor(Map<String, dynamic> provider) {
    final name = provider['name'] as String;
    return _companyReports.putIfAbsent(name, () {
      return _companyAi.buildReport(
        provider: ProviderModel(
          id: name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
          name: name,
          location: provider['location'] as String,
          category: 'Empaques',
          description: 'Proveedor candidato para cotizacion de empaques plasticos y soluciones B2B.',
          logo: name.substring(0, 2).toUpperCase(),
          rating: provider['rating'] as double,
          reviews: name.contains('PlastiPack')
              ? 128
              : name.contains('Evanplast')
                  ? 89
                  : 64,
          years: name.contains('PlastiPack')
              ? 16
              : name.contains('Evanplast')
                  ? 12
                  : 9,
          responseTime: provider['response'] as String,
          featured: provider['tag'] == 'Top Verificado',
        ),
        product: _productCtrl.text,
        description: _descCtrl.text,
        quantity: _quantityCtrl.text,
        budget: _budgetCtrl.text,
        deliveryLocation: _locationCtrl.text,
        requirements: _selectedFeatures,
      );
    });
  }

  /// Abre un enlace externo (red social, sitio web, ficha técnica) en el navegador del dispositivo
  static Future<void> _openSource(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _productCtrl.dispose();
    _descCtrl.dispose();
    _quantityCtrl.dispose();
    _budgetCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  /// Avanza al siguiente paso del asistente o ejecuta el envío final en el paso 2
  void _next() {
    if (step < 2) {
      if (step == 0) _companyReports.clear();
      setState(() => step++);
    } else {
      _submitQuotation();
    }
  }

  /// Retrocede al paso anterior o cierra la pantalla si está en el paso inicial
  void _previous() {
    if (step > 0) {
      setState(() => step--);
    } else {
      Navigator.pop(context);
    }
  }

  /// Registra la cotización en Firestore y notifica a los proveedores seleccionados
  Future<void> _submitQuotation() async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final selectedProviders = _providers.where((p) => p['selected'] == true).toList();
    final providerLabel = selectedProviders.isEmpty
        ? 'Sin proveedor seleccionado'
        : selectedProviders.map((p) => p['name']).join(' & ');
    final bestRating = selectedProviders.isEmpty
        ? 0.0
        : selectedProviders.map((p) => p['rating'] as double).reduce((a, b) => a > b ? a : b);

    // Guardar cotización en Firestore
    await FirestoreRepository().saveQuotation(
      QuotationModel(
        provider: '$providerLabel (Solicitud IA reforzada)',
        price: 11500,
        deliveryDays: 4,
        rating: bestRating,
        distance: 8.2,
        status: 'Pendiente',
      ),
      id: 'quote_${DateTime.now().millisecondsSinceEpoch}',
    );

    messenger.showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.trustGreen,
        content: Text('🎉 ¡Solicitud de cotización enviada exitosamente a los fabricantes seleccionados!'),
      ),
    );
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final title = step == 0
        ? 'Especificaciones del Requerimiento'
        : step == 1
            ? 'Seleccionar Fabricantes Destinatarios'
            : 'Confirmación y Envío de Cotización';

    final subtitle = step == 0
        ? 'Detalla las características y volumen para que los proveedores te envíen su mejor precio.'
        : step == 1
            ? 'Elige qué empresas verificadas recibirán tu solicitud y competirán por tu orden.'
            : 'Revisa el resumen antes de notificar a los ejecutivos comerciales.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Cotizaciones'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. BANNER HERO: Indicador visual del wizard de pasos
          // ------------------------------------------------------------------
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
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SOLICITAR COTIZACIÓN B2B',
                        style: TextStyle(
                          color: AppColors.trustGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Wizard de Pasos
                      _StepWizardProgress(currentStep: step),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. CONTENIDO DEL PASO ACTIVO
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 24),

                        if (step == 0) _buildStep0(),
                        if (step == 1) _buildStep1(),
                        if (step == 2) _buildStep2(),

                        const SizedBox(height: 32),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Fila de Botones: Anterior Y Siguiente
                        Row(
                          children: [
                            // Botón Anterior (Siempre disponible)
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: const BorderSide(color: AppColors.border, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: _previous,
                                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                                label: Text(
                                  step == 0 ? 'Cancelar' : 'Anterior',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Botón Siguiente / Enviar
                            Expanded(
                              flex: 2,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: step == 2 ? AppColors.trustGreen : AppColors.navy,
                                  elevation: 3,
                                  shadowColor: (step == 2 ? AppColors.trustGreen : AppColors.navy).withValues(alpha: 0.3),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: _next,
                                icon: Icon(step == 2 ? Icons.send_rounded : Icons.arrow_forward_rounded, size: 18),
                                label: Text(
                                  step == 2 ? 'Enviar Solicitud a Proveedores' : 'Continuar al Paso ${step + 2}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  // ── PASO 0: DETALLES Y ESPECIFICACIONES ──────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _productCtrl,
          decoration: InputDecoration(
            labelText: '¿Qué producto o insumo necesitas?',
            hintText: 'Ej. Galoneras de 1 Galón HDPE y Frascos PET',
            filled: true,
            fillColor: AppColors.background,
            prefixIcon: const Icon(Icons.inventory_2_outlined, color: AppColors.navy),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Descripción detallada del requerimiento',
            hintText: 'Especifica medidas, materiales, tapas herméticas, uso previsto...',
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quantityCtrl,
                decoration: InputDecoration(
                  labelText: 'Cantidad requerida',
                  filled: true,
                  fillColor: AppColors.background,
                  prefixIcon: const Icon(Icons.numbers_rounded, color: AppColors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _budgetCtrl,
                decoration: InputDecoration(
                  labelText: 'Presupuesto estimado',
                  filled: true,
                  fillColor: AppColors.background,
                  prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.trustGreen),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _locationCtrl,
          decoration: InputDecoration(
            labelText: 'Dirección o departamento de entrega',
            filled: true,
            fillColor: AppColors.background,
            prefixIcon: const Icon(Icons.place_outlined, color: AppColors.blue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Requisitos especiales (Selecciona los aplicables):',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _features.map((f) {
            final isSelected = _selectedFeatures.contains(f);
            return FilterChip(
              label: Text(f),
              selected: isSelected,
              selectedColor: AppColors.paleGreen,
              checkmarkColor: AppColors.trustGreen,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.trustGreen : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedFeatures.add(f);
                  } else {
                    _selectedFeatures.remove(f);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── PASO 1: SELECCIÓN DE FABRICANTES ─────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona los proveedores que recibirán tu requerimiento:',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 14),
        ..._providers.map((p) {
          final isSelected = p['selected'] as bool;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.paleBlue : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.blue : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: CheckboxListTile(
                  value: isSelected,
                  activeColor: AppColors.navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onChanged: (val) {
                    setState(() {
                      p['selected'] = val ?? false;
                      if (p['selected'] == true) _reportFor(p);
                    });
                  },
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.trustGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          p['tag'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${p['location']} • ${p['rating']} ★ • Responde en ${p['response']}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ),
              if (isSelected)
                FutureBuilder<CompanyIntelligenceReport>(
                  future: _reportFor(p),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const _CompanyIntelligenceLoading();
                    }
                    return _CompanyIntelligencePanel(report: snapshot.data!);
                  },
                ),
            ],
          );
        }),
      ],
    );
  }

  // ── PASO 2: CONFIRMACIÓN Y ENVÍO ────────────────────────────────────
  Widget _buildStep2() {
    final selectedCount = _providers.where((p) => p['selected'] == true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.paleGreen,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.trustGreen.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.trustGreen, size: 36),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solicitud Lista para Notificación Inmediata',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Se notificará a $selectedCount proveedores verificados con canales de venta activos.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text('Resumen del Pedido:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 12),
        _SummaryRow(label: 'Producto:', value: _productCtrl.text),
        const Divider(height: 1),
        _SummaryRow(label: 'Volumen:', value: _quantityCtrl.text),
        const Divider(height: 1),
        _SummaryRow(label: 'Presupuesto:', value: _budgetCtrl.text),
        const Divider(height: 1),
        _SummaryRow(label: 'Ubicación:', value: _locationCtrl.text),
        const Divider(height: 1),
        _SummaryRow(
          label: 'Proveedores:',
          value: _providers.where((p) => p['selected'] == true).map((p) => p['name']).join(', '),
        ),
        const SizedBox(height: 18),
        const Text('Checklist IA para compra satisfecha:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 10),
        const _AiChecklistItem(text: 'Validar actividad de la empresa en Google, Facebook, Instagram, TikTok y YouTube.'),
        const _AiChecklistItem(text: 'Solicitar muestra, ficha tecnica, MOQ, precio final y fecha exacta de entrega.'),
        const _AiChecklistItem(text: 'Confirmar condiciones por escrito antes de emitir orden de compra.'),
      ],
    );
  }
}

// ── Fila de Resumen ───────────────────────────────────────────────────
/// Indicador de carga animado mientras se construye el reporte de inteligencia comercial.
class _CompanyIntelligenceLoading extends StatelessWidget {
  const _CompanyIntelligenceLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.trustGreen),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'IA fortaleciendo datos de empresa y preparando fuentes externas...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel de inteligencia comercial generado por IA con fuentes web y preguntas recomendadas.
class _CompanyIntelligencePanel extends StatelessWidget {
  final CompanyIntelligenceReport report;

  const _CompanyIntelligencePanel({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.trustGreen.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.trustGreen, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'IA de respaldo: ${report.providerName}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.trustGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${report.confidenceScore}% confianza',
                  style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(report.summary, style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.45)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: report.sources.map((source) {
              return ActionChip(
                avatar: const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.navy),
                label: Text(source.name),
                labelStyle: const TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.w800),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                onPressed: () => _QuotationRequestScreenState._openSource(source.url),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ...report.recommendedQuestions.take(2).map(
                (question) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.trustGreen, size: 15),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(question, style: const TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.35)),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// Elemento con icono de verificación para las pautas del checklist de compras.
class _AiChecklistItem extends StatelessWidget {
  final String text;

  const _AiChecklistItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.task_alt_rounded, color: AppColors.trustGreen, size: 17),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5))),
        ],
      ),
    );
  }
}

/// Fila estructurada de etiqueta y valor para el resumen final de la cotización.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

// ── Wizard de Progreso ────────────────────────────────────────────────
/// Barra horizontal que dibuja los nodos numéricos y líneas de conexión entre pasos.
class _StepWizardProgress extends StatelessWidget {
  final int currentStep;

  const _StepWizardProgress({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Node(num: '1', label: 'Detalles', active: currentStep >= 0, isCurrent: currentStep == 0),
        _Line(active: currentStep >= 1),
        _Node(num: '2', label: 'Proveedores', active: currentStep >= 1, isCurrent: currentStep == 1),
        _Line(active: currentStep >= 2),
        _Node(num: '3', label: 'Confirmar', active: currentStep >= 2, isCurrent: currentStep == 2),
      ],
    );
  }
}

/// Nodo circular numerado del paso en el wizard.
class _Node extends StatelessWidget {
  final String num;
  final String label;
  final bool active;
  final bool isCurrent;

  const _Node({required this.num, required this.label, required this.active, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? AppColors.trustGreen
                : active
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Text(
              num,
              style: TextStyle(
                color: isCurrent
                    ? Colors.white
                    : active
                        ? AppColors.navy
                        : Colors.white54,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white54,
            fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Línea divisoria entre nodos del wizard con iluminación de avance.
class _Line extends StatelessWidget {
  final bool active;

  const _Line({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 2,
        color: active ? AppColors.trustGreen : Colors.white24,
      ),
    );
  }
}


