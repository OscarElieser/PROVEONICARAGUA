import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/ai/gemini_recommendation_service.dart';
import '../services/firebase/firestore_repository.dart';
import 'chat_screen.dart';

/// Comparador Inteligente y Matriz Comparativa B2B de PROVEO.
class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final _geminiService = GeminiService();
  String? _aiVerdict;
  bool _loadingAi = true;

  @override
  void initState() {
    super.initState();
    _fetchAiVerdict();
  }

  Future<void> _fetchAiVerdict() async {
    try {
      const prompt = '''Eres el Asesor Senior de Compras B2B de PROVEO Nicaragua.
Realiza un análisis comparativo y veredicto final para 3 cotizaciones recibidas:
1. PlastiPack Nicaragua (C\$12,500, Entrega: 4 días, 4.8★, 8.2 km, Top Verificado)
2. Evanplast S.A. (C\$10,900, Entrega: 6 días, 4.6★, 32.4 km, Mejor Precio)
3. Innoplast (C\$11,700, Entrega: 5 días, 4.5★, 92.1 km, Balanceado)

En 3 oraciones concisas:
- Menciona cuál conviene para entrega urgente.
- Menciona cuál conviene para ahorro máximo.
- Da tu veredicto de decisión inteligente para el negocio.''';

      final response = await _geminiService.generarRespuesta(prompt);
      if (mounted) {
        setState(() {
          _aiVerdict = response;
          _loadingAi = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _aiVerdict = 'PlastiPack Nicaragua es la opción óptima para despachos urgentes y máxima garantía. Para ahorro presupuestario, Evanplast S.A. ofrece el mejor precio por volumen con entrega a 6 días.';
          _loadingAi = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Banner Hero
          SliverAppBar(
            expandedHeight: 180,
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
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.trustGreen,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 14),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comparador Inteligente B2B',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Matriz de decisión ponderada con IA',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
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
          ),

          // Contenido Comparativo
          SliverToBoxAdapter(
            child: FutureBuilder<List<QuotationModel>>(
              future: FirestoreRepository().getQuotations(),
              builder: (context, snapshot) {
                final quotations = snapshot.data ?? [];

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Tarjeta de Veredicto IA
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.navy, AppColors.blue],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.navy.withValues(alpha: 0.2),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: AppColors.trustGreen, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Veredicto Comparativo Gemini AI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (_loadingAi)
                                  const Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(color: AppColors.trustGreen, strokeWidth: 2),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Analizando variables de costo, tiempo y distancia...',
                                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    ],
                                  )
                                else
                                  Text(
                                    _aiVerdict ?? '',
                                    style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.45),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Matriz Comparativa (Tarjetas Lado a Lado)
                          const Text(
                            'Matriz de Proveedores Cotizantes',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Revisa las especificaciones clave antes de adjudicar tu compra B2B.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 16),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 700;
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: quotations.map((q) {
                                  final width = isWide ? (constraints.maxWidth - 32) / 3 : double.infinity;
                                  final isBestPrice = q.provider.contains('Evanplast') || q.price <= 10900;
                                  final isFastest = q.provider.contains('PlastiPack') || q.deliveryDays <= 4;

                                  return SizedBox(
                                    width: width,
                                    child: _ComparisonCard(
                                      quotation: q,
                                      isBestPrice: isBestPrice,
                                      isFastest: isFastest,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // Tabla Desglosada de Criterios
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tabla Comparativa de Criterios',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                                  ),
                                  SizedBox(height: 16),
                                  _CriteriaRow(
                                    criteria: 'Precio Cotizado',
                                    val1: 'C\$12,500',
                                    val2: 'C\$10,900 (Mínimo)',
                                    val3: 'C\$11,700',
                                    winnerIndex: 2,
                                  ),
                                  Divider(height: 1),
                                  _CriteriaRow(
                                    criteria: 'Tiempo de Entrega',
                                    val1: '4 días (Rápido)',
                                    val2: '6 días',
                                    val3: '5 días',
                                    winnerIndex: 1,
                                  ),
                                  Divider(height: 1),
                                  _CriteriaRow(
                                    criteria: 'Distancia Logística',
                                    val1: '8.2 km (Managua)',
                                    val2: '32.4 km (Masaya)',
                                    val3: '92.1 km (León)',
                                    winnerIndex: 1,
                                  ),
                                  Divider(height: 1),
                                  _CriteriaRow(
                                    criteria: 'Reputación & Review',
                                    val1: '4.8 ★ (120+ rev.)',
                                    val2: '4.6 ★ (85 rev.)',
                                    val3: '4.5 ★ (40 rev.)',
                                    winnerIndex: 1,
                                  ),
                                  Divider(height: 1),
                                  _CriteriaRow(
                                    criteria: 'Muestras Previas',
                                    val1: 'Gratis 24h',
                                    val2: 'Bajo solicitud',
                                    val3: 'Gratis 48h',
                                    winnerIndex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta Individual en la Matriz Comparativa ───────────────────────
class _ComparisonCard extends StatelessWidget {
  final QuotationModel quotation;
  final bool isBestPrice;
  final bool isFastest;

  const _ComparisonCard({
    required this.quotation,
    required this.isBestPrice,
    required this.isFastest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isFastest
              ? AppColors.navy
              : isBestPrice
                  ? AppColors.trustGreen
                  : AppColors.border,
          width: isFastest || isBestPrice ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isBestPrice
                ? AppColors.trustGreen.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge superior
            if (isFastest)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⚡ Entrega Más Rápida',
                  style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              )
            else if (isBestPrice)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.trustGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '💰 Precio Más Bajo',
                  style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paleBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '⚖️ Opción Equilibrada',
                  style: TextStyle(color: AppColors.navy, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ),

            Text(
              quotation.provider,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                const SizedBox(width: 3),
                Text('${quotation.rating} ★', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 8),
                Text('• ${quotation.distance} km', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text(
                        'C\$ ${quotation.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isBestPrice ? AppColors.trustGreen : AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Despacho:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text(
                        '${quotation.deliveryDays} días',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botones de acción directa
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isBestPrice ? AppColors.trustGreen : AppColors.navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.trustGreen,
                      content: Text('¡Cotización de "${quotation.provider}" seleccionada!'),
                    ),
                  );
                },
                child: const Text('Elegir Esta Oferta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                label: const Text('Negociar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fila de Criterio en Tabla ─────────────────────────────────────────
class _CriteriaRow extends StatelessWidget {
  final String criteria;
  final String val1;
  final String val2;
  final String val3;
  final int winnerIndex;

  const _CriteriaRow({
    required this.criteria,
    required this.val1,
    required this.val2,
    required this.val3,
    required this.winnerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              criteria,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              val1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: winnerIndex == 1 ? FontWeight.w900 : FontWeight.w500,
                color: winnerIndex == 1 ? AppColors.navy : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              val2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: winnerIndex == 2 ? FontWeight.w900 : FontWeight.w500,
                color: winnerIndex == 2 ? AppColors.trustGreen : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              val3,
              style: TextStyle(
                fontSize: 12,
                fontWeight: winnerIndex == 3 ? FontWeight.w900 : FontWeight.w500,
                color: winnerIndex == 3 ? AppColors.teal : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
