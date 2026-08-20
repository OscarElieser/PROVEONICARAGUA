import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'comparison_screen.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header moderno
          SliverAppBar(
            expandedHeight: 170,
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
                    // Círculos decorativos
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
                    Positioned(
                      left: 50,
                      bottom: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mis Cotizaciones',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Text(
                                    'Compara precios y elige lo mejor',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => const ComparisonScreen())),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.trustGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                                label: const Text('Comparar',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
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

          // Cuerpo con cotizaciones
          SliverToBoxAdapter(
            child: FutureBuilder<List<QuotationModel>>(
              future: FirestoreRepository().getQuotations(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const _EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: 'No pudimos cargar tus cotizaciones',
                    subtitle: 'Revisa tu conexión e intenta de nuevo.',
                    color: AppColors.error,
                  );
                }
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.teal,
                      ),
                    ),
                  );
                }
                final quotations = snapshot.data!;
                if (quotations.isEmpty) {
                  return const _EmptyState(
                    icon: Icons.inbox_rounded,
                    title: 'Aún no tienes cotizaciones',
                    subtitle: 'Busca proveedores y solicita tu primera cotización.',
                    color: AppColors.textSecondary,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Resumen stats
                      Row(
                        children: [
                          _QuickStat(
                            value: '${quotations.length}',
                            label: 'Cotizaciones',
                            icon: Icons.receipt_long_rounded,
                            color: AppColors.blue,
                          ),
                          const SizedBox(width: 12),
                          _QuickStat(
                            value: 'C\$${_minPrice(quotations).toStringAsFixed(0)}',
                            label: 'Precio mínimo',
                            icon: Icons.trending_down_rounded,
                            color: AppColors.trustGreen,
                          ),
                          const SizedBox(width: 12),
                          _QuickStat(
                            value: '${_fastestDelivery(quotations)} días',
                            label: 'Entrega rápida',
                            icon: Icons.local_shipping_outlined,
                            color: AppColors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Proveedores cotizando',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),

                      // Lista de cotizaciones
                      ...quotations.asMap().entries.map((entry) {
                        final i = entry.key;
                        final q = entry.value;
                        final isBest = q.price == _minPrice(quotations);
                        return _QuotationCard(
                          quotation: q,
                          rank: i + 1,
                          isBest: isBest,
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _minPrice(List<QuotationModel> q) =>
      q.map((e) => e.price).reduce((a, b) => a < b ? a : b);

  int _fastestDelivery(List<QuotationModel> q) =>
      q.map((e) => e.deliveryDays).reduce((a, b) => a < b ? a : b);
}

// ── Tarjeta de Cotización ─────────────────────────────────────────────
class _QuotationCard extends StatelessWidget {
  final QuotationModel quotation;
  final int rank;
  final bool isBest;

  const _QuotationCard({
    required this.quotation,
    required this.rank,
    required this.isBest,
  });

  Color get _statusColor {
    switch (quotation.status.toLowerCase()) {
      case 'aceptada':
        return AppColors.trustGreen;
      case 'pendiente':
        return AppColors.warning;
      case 'rechazada':
        return AppColors.error;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isBest
            ? Border.all(color: AppColors.trustGreen, width: 2)
            : Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: isBest
                ? AppColors.trustGreen.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera de tarjeta
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            decoration: BoxDecoration(
              color: isBest
                  ? AppColors.trustGreen.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                // Número de ranking
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isBest ? AppColors.trustGreen : AppColors.paleBlue,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isBest ? Colors.white : AppColors.navy,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              quotation.provider,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isBest)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.trustGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '✓ Mejor precio',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Estrellas
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < quotation.rating.floor()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.warning,
                            size: 14,
                          );
                        })
                          ..add(
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                quotation.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Detalle de métricas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                _MetricChip(
                  icon: Icons.attach_money_rounded,
                  label: 'C\$${quotation.price.toStringAsFixed(0)}',
                  color: isBest ? AppColors.trustGreen : AppColors.navy,
                  filled: isBest,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  icon: Icons.local_shipping_outlined,
                  label: '${quotation.deliveryDays} días',
                  color: AppColors.teal,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  icon: Icons.place_outlined,
                  label: '${quotation.distance.toStringAsFixed(1)} km',
                  color: AppColors.blue,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    quotation.status,
                    style: TextStyle(
                        color: _statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Negociar',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          isBest ? AppColors.trustGreen : AppColors.navy,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Aceptar',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip de métrica ───────────────────────────────────────────────────
class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: filled ? Colors.white : color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: filled ? Colors.white : color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Estadística rápida ────────────────────────────────────────────────
class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _QuickStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Estado vacío ──────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
