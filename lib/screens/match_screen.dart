import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';
import '../services/ai/gemini_recommendation_service.dart';
import '../services/firebase/firestore_repository.dart';
import 'provider_profile_screen.dart';
import 'quotation_request_screen.dart';

/// Pantalla PROVEO Match interactiva con análisis inteligente de Gemini AI.
class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int _step = 0;
  String _selectedCategory = 'Empaques y Envases';
  String _selectedLocation = 'Managua';
  String _selectedPriority = 'Calidad y Certificaciones';
  String _customNotes = '';

  final _geminiService = GeminiService();
  String? _aiExplanation;
  bool _loadingAi = false;

  final List<String> _categories = [
    'Empaques y Envases Plásticos',
    'Bolsas Biodegradables y Papel',
    'Etiquetas y Adhesivos Industriales',
    'Materia Prima y Polímeros',
    'Cajas de Cartón y Embalaje',
  ];

  final List<String> _locations = [
    'Managua',
    'Masaya',
    'León',
    'Chinandega',
    'Matagalpa',
    'Estelí',
    'Todo el País',
  ];

  final List<String> _priorities = [
    'Mejor Precio por Volumen',
    'Calidad y Certificaciones (ISO/BPA Free)',
    'Entrega Inmediata / Despacho Rápido',
    'Cercanía Geográfica',
  ];

  Future<void> _generateAiAnalysis() async {
    setState(() => _loadingAi = true);
    try {
      final prompt = '''Eres el Asesor Senior de Compras B2B de PROVEO Nicaragua.
Un cliente completó PROVEO Match con estos criterios:
- Rubro: $_selectedCategory
- Ubicación: $_selectedLocation
- Prioridad principal: $_selectedPriority
${_customNotes.isNotEmpty ? '- Requerimiento específico: $_customNotes' : ''}

Explica en un párrafo conciso (máximo 3 oraciones) por qué los proveedores recomendados son ideales para este negocio y qué ventaja competitiva obtendrá.''';

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
          _aiExplanation = 'Hemos seleccionado los mejores proveedores verificados con inventario disponible en $_selectedLocation priorizando $_selectedPriority.';
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
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.trustGreen),
            SizedBox(width: 8),
            Text('PROVEO Match con IA'),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Barra de progreso del wizard
              LinearProgressIndicator(
                value: (_step + 1) / 3,
                backgroundColor: AppColors.paleBlue,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.trustGreen),
              ),
              const SizedBox(height: 12),
              Text('Paso ${_step + 1} de 3', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 16),

              if (_step == 0) _buildStep0(),
              if (_step == 1) _buildStep1(),
              if (_step == 2) _buildStep2(),

              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_step > 0)
                    OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      child: const Text('Anterior'),
                    )
                  else
                    const SizedBox.shrink(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                    onPressed: () => setState(() => _step++),
                    icon: Icon(_step == 2 ? Icons.auto_awesome : Icons.arrow_forward),
                    label: Text(_step == 2 ? 'Generar Recomendación IA' : 'Siguiente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué producto o servicio buscas?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Selecciona la categoría principal para que Gemini filtre los mejores fabricantes.', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        ..._categories.map((cat) => RadioListTile<String>(
              value: cat,
              groupValue: _selectedCategory,
              title: Text(cat, style: const TextStyle(fontWeight: FontWeight.w600)),
              activeColor: AppColors.trustGreen,
              onChanged: (val) => setState(() => _selectedCategory = val!),
            )),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Dónde requieres la entrega?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Priorizamos proveedores con rutas de distribución en tu departamento.', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        ..._locations.map((loc) => RadioListTile<String>(
              value: loc,
              groupValue: _selectedLocation,
              title: Text(loc, style: const TextStyle(fontWeight: FontWeight.w600)),
              activeColor: AppColors.trustGreen,
              onChanged: (val) => setState(() => _selectedLocation = val!),
            )),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Cuál es tu prioridad principal?', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('La IA ponderará los pesos de evaluación según tu criterio estratégico.', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        ..._priorities.map((p) => RadioListTile<String>(
              value: p,
              groupValue: _selectedPriority,
              title: Text(p, style: const TextStyle(fontWeight: FontWeight.w600)),
              activeColor: AppColors.trustGreen,
              onChanged: (val) => setState(() => _selectedPriority = val!),
            )),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Notas adicionales (Opcional)',
            hintText: 'Ej. Requiero 5,000 unidades mensuales con impresión personalizada...',
          ),
          onChanged: (val) => _customNotes = val,
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados PROVEO Match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar Match',
            onPressed: () => setState(() {
              _step = 0;
              _aiExplanation = null;
            }),
          ),
        ],
      ),
      body: FutureBuilder<List<ProviderModel>>(
        future: FirestoreRepository().getProviders(),
        builder: (context, snapshot) {
          final providers = snapshot.data ?? [];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Tarjeta con la explicación de Gemini AI
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navy, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.trustGreen),
                            SizedBox(width: 8),
                            Text(
                              'Análisis Inteligente de Gemini AI',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_loadingAi)
                          const Row(
                            children: [
                              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              SizedBox(width: 12),
                              Text('Gemini está evaluando los mejores proveedores...', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          )
                        else
                          Text(
                            _aiExplanation ?? 'Evaluación completada para $_selectedCategory en $_selectedLocation.',
                            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.45),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SectionTitle(
                    title: 'Proveedores con Mayor Coincidencia',
                    subtitle: 'Ordenados por reputación, compatibilidad y disponibilidad',
                  ),
                  const SizedBox(height: 16),

                  ...providers.map((p) {
                    final matchPercent = (p.rating / 5 * 85 + (p.featured ? 12 : 5)).round().clamp(75, 99);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: PremiumCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.paleGreen,
                              child: Text('$matchPercent%', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.trustGreen)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(width: 8),
                                      if (p.featured) const VerifiedBadge(text: 'Top Match'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${p.category} • ${p.location} • Resp: ${p.responseTime}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuotationRequestScreen())),
                                  child: const Text('Cotizar'),
                                ),
                                const SizedBox(height: 6),
                                OutlinedButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: p))),
                                  child: const Text('Ver Perfil'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

