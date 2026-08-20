import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';
import 'chat_screen.dart';
import 'comparison_screen.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  final _repository = FirestoreRepository();
  List<QuotationModel>? _quotations;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotations();
  }

  Future<void> _loadQuotations() async {
    final list = await _repository.getQuotations();
    if (mounted) {
      setState(() {
        _quotations = list;
        _loading = false;
      });
    }
  }

  void _acceptQuotation(QuotationModel q, int index) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.trustGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.trustGreen, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('¿Aceptar Cotización?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estás por adjudicar la orden a "${q.provider}" por un monto de C\$ ${q.price.toStringAsFixed(2)} con entrega en ${q.deliveryDays} días.',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.paleGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.trustGreen, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PROVEO garantiza la trazabilidad comercial de esta orden.',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Volver'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.trustGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              setState(() {
                _quotations![index] = QuotationModel(
                  provider: q.provider,
                  price: q.price,
                  deliveryDays: q.deliveryDays,
                  rating: q.rating,
                  distance: q.distance,
                  status: 'Aceptada',
                );
              });
              await _repository.saveQuotation(_quotations![index], id: 'quote_$index');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.trustGreen,
                    content: Text('🎉 ¡Cotización de "${q.provider}" ACEPTADA con éxito!'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Confirmar y Aceptar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _rejectQuotation(QuotationModel q, int index) {
    String selectedReason = 'Precio fuera de presupuesto';
    final reasons = [
      'Precio fuera de presupuesto',
      'Tiempo de entrega muy largo',
      'Elegí otra propuesta más competitiva',
      'Especificaciones no coinciden',
    ];

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 26),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Rechazar Cotización', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Indica el motivo para notificar a "${q.provider}":', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              ...reasons.map((r) => RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: r,
                    groupValue: selectedReason,
                    title: Text(r, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    activeColor: AppColors.error,
                    onChanged: (val) => setDialogState(() => selectedReason = val!),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(dialogCtx);
                setState(() {
                  _quotations![index] = QuotationModel(
                    provider: q.provider,
                    price: q.price,
                    deliveryDays: q.deliveryDays,
                    rating: q.rating,
                    distance: q.distance,
                    status: 'Rechazada',
                  );
                });
                await _repository.saveQuotation(_quotations![index], id: 'quote_$index');
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Cotización de "${q.provider}" rechazada ($selectedReason).'),
                  ),
                );
              },
              child: const Text('Rechazar Oferta', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _negotiateQuotation(QuotationModel q) {
    final counterOfferCtrl = TextEditingController(text: (q.price * 0.90).toStringAsFixed(0));
    final messageCtrl = TextEditingController(
        text: 'Hola ${q.provider}, nos interesa su propuesta. ¿Podrían ajustar el monto o los días de entrega por pago al contado?');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.blue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Negociar con ${q.provider}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                      Text('Precio actual: C\$ ${q.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(sheetCtx),
                ),
              ],
            ),
            const Divider(height: 24),

            // Tip de Asesor Gemini
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, AppColors.blue],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.trustGreen, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Consejo Gemini B2B: Los fabricantes suelen aceptar un 5-10% de descuento si consolidas compras a 3 meses.',
                      style: TextStyle(color: Colors.white, fontSize: 12, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: counterOfferCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Contraoferta propuesta (C\$ Córdobas)',
                prefixText: 'C\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mensaje para el ejecutivo de ventas',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.blue,
                      content: Text('Contraoferta de C\$ ${counterOfferCtrl.text} enviada a ${q.provider}.'),
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Enviar Propuesta al Chat B2B', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Cotizaciones'),
      body: CustomScrollView(
        slivers: [
          // Header moderno con degradado
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
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mis Cotizaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gestiona, negocia y acepta ofertas en tiempo real',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ComparisonScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.trustGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                        label: const Text('Comparar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Cuerpo interactivo
          SliverToBoxAdapter(
            child: _loading
                ? const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator(color: AppColors.teal)),
                  )
                : _quotations == null || _quotations!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: AppColors.paleBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.navy),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No tienes cotizaciones registradas',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Explora proveedores y solicita cotizaciones para verlas aquí.',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${_quotations!.length} Propuestas Recibidas',
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.navy),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.paleBlue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Ordenado por Recomendación',
                                          style: TextStyle(color: AppColors.navy, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Lista de cotizaciones interactivas
                                ..._quotations!.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final q = entry.value;
                                  final isBest = q.price == _minPrice(_quotations!);
                                  return _QuotationCard(
                                    quotation: q,
                                    rank: i + 1,
                                    isBest: isBest,
                                    onAccept: () => _acceptQuotation(q, i),
                                    onReject: () => _rejectQuotation(q, i),
                                    onNegotiate: () => _negotiateQuotation(q),
                                  );
                                }),
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

  double _minPrice(List<QuotationModel> q) =>
      q.map((e) => e.price).reduce((a, b) => a < b ? a : b);
}

// ── Tarjeta de Cotización Interactiva ─────────────────────────────────
class _QuotationCard extends StatelessWidget {
  final QuotationModel quotation;
  final int rank;
  final bool isBest;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onNegotiate;

  const _QuotationCard({
    required this.quotation,
    required this.rank,
    required this.isBest,
    required this.onAccept,
    required this.onReject,
    required this.onNegotiate,
  });

  Color get _statusColor {
    switch (quotation.status.toLowerCase()) {
      case 'aceptada':
        return AppColors.trustGreen;
      case 'rechazada':
        return AppColors.error;
      case 'pendiente':
        return AppColors.warning;
      default:
        return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAccepted = quotation.status.toLowerCase() == 'aceptada';
    final isRejected = quotation.status.toLowerCase() == 'rechazada';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: isAccepted
            ? Border.all(color: AppColors.trustGreen, width: 2.2)
            : isRejected
                ? Border.all(color: AppColors.error.withValues(alpha: 0.5), width: 1.5)
                : isBest
                    ? Border.all(color: AppColors.trustGreen, width: 2)
                    : Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: isAccepted
                ? AppColors.trustGreen.withValues(alpha: 0.15)
                : isBest
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
              color: isAccepted
                  ? AppColors.trustGreen.withValues(alpha: 0.08)
                  : isBest
                      ? AppColors.trustGreen.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                // Número de ranking
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAccepted || isBest ? AppColors.trustGreen : AppColors.paleBlue,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isAccepted || isBest ? Colors.white : AppColors.navy,
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
                          if (isBest && !isAccepted && !isRejected)
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
                  color: isAccepted || isBest ? AppColors.trustGreen : AppColors.navy,
                  filled: isAccepted || isBest,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _statusColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAccepted
                            ? Icons.check_circle_rounded
                            : isRejected
                                ? Icons.cancel_rounded
                                : Icons.pending_rounded,
                        size: 12,
                        color: _statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        quotation.status,
                        style: TextStyle(
                            color: _statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fila de Botones: Negociar, Rechazar y Aceptar
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Row(
              children: [
                // Botón Negociar
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: isAccepted || isRejected ? null : onNegotiate,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                    label: const Text('Negociar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón Rechazar (Nuevo)
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: isAccepted || isRejected ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 15, color: AppColors.error),
                    label: const Text('Rechazar', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón Aceptar
                Expanded(
                  flex: 4,
                  child: FilledButton.icon(
                    onPressed: isAccepted || isRejected ? null : onAccept,
                    style: FilledButton.styleFrom(
                      backgroundColor: isAccepted ? AppColors.trustGreen : AppColors.navy,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: Icon(isAccepted ? Icons.verified_rounded : Icons.check_circle_outline_rounded, size: 16),
                    label: Text(
                      isAccepted ? 'Adjudicada' : 'Aceptar',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
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
