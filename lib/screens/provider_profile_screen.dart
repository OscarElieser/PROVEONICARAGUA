import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import 'chat_screen.dart';
import 'quotation_request_screen.dart';

/// Perfil y Catálogo Empresarial B2B Ultra-Premium de PROVEO.
class ProviderProfileScreen extends StatelessWidget {
  final ProviderModel provider;

  const ProviderProfileScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Banner Hero con degradado y datos principales
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
                    // Círculos decorativos de fondo
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
                            // Logo / Avatar de la Empresa
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
                                  provider.name.isNotEmpty ? provider.name.substring(0, 2).toUpperCase() : 'PR',
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
                                          provider.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (provider.featured)
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
                                              Text(
                                                'Top Verificado',
                                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${provider.category} • ${provider.location}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${provider.rating} (${provider.reviews} opiniones)',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text('•', style: TextStyle(color: Colors.white54)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Resp: ${provider.responseTime}',
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

          // Contenido Detallado
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Barra de Acciones Comerciales Directas
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
                              label: const Text(
                                'Solicitar Cotización',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                              ),
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
                              label: const Text(
                                'Chat B2B',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sobre la Empresa
                      _CardSection(
                        title: 'Acerca del Fabricante',
                        icon: Icons.info_outline_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.description,
                              style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoBadge(icon: Icons.business_center_outlined, text: '${provider.years} años de experiencia'),
                                const _InfoBadge(icon: Icons.verified_user_outlined, text: 'RUC y DGI Verificado'),
                                const _InfoBadge(icon: Icons.local_shipping_outlined, text: 'Flotilla propia de reparto'),
                                const _InfoBadge(icon: Icons.inventory_2_outlined, text: 'Venta Mayorista y Menudeo'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Catálogo Destacado de Productos
                      const _CardSection(
                        title: 'Catálogo de Productos & Líneas de Producción',
                        icon: Icons.category_rounded,
                        child: Column(
                          children: [
                            _ProductItem(
                              title: 'Galoneras y Bidones Plásticos (1 Gal - 5 Gal)',
                              subtitle: 'Polietileno de alta densidad (HDPE), tapa con precinto de seguridad.',
                              price: 'C\$ 18.50 - C\$ 45.00 / unidad',
                              moq: 'MOQ: 100 unidades',
                              color: AppColors.blue,
                            ),
                            Divider(height: 1),
                            _ProductItem(
                              title: 'Frascos PET Transparentes con Tapa Rosca',
                              subtitle: 'Grado alimenticio y farmacéutico. Tamaños: 250ml, 500ml y 1000ml.',
                              price: 'C\$ 8.20 - C\$ 14.50 / unidad',
                              moq: 'MOQ: 500 unidades',
                              color: AppColors.teal,
                            ),
                            Divider(height: 1),
                            _ProductItem(
                              title: 'Bolsas Industriales Tipo Camiseta y Rollo',
                              subtitle: 'Material reciclado o virgen de alta resistencia con opción de serigrafía.',
                              price: 'C\$ 0.45 - C\$ 1.20 / unidad',
                              moq: 'MOQ: 1,000 unidades',
                              color: AppColors.trustGreen,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Círculo Dorado de Confianza PROVEO
                      const _CardSection(
                        title: 'Círculo Dorado de Calificación B2B',
                        icon: Icons.workspace_premium_rounded,
                        child: Column(
                          children: [
                            _ScoreBar(label: 'Calidad y Especificaciones de Material', score: 4.9),
                            SizedBox(height: 12),
                            _ScoreBar(label: 'Cumplimiento de Fechas de Entrega', score: 4.8),
                            SizedBox(height: 12),
                            _ScoreBar(label: 'Capacidad de Respuesta y Atención', score: 4.7),
                            SizedBox(height: 12),
                            _ScoreBar(label: 'Competitividad en Precios y Crédito', score: 4.6),
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
        ],
      ),
    );
  }
}

// ── Tarjeta Contenedora de Sección ────────────────────────────────────
class _CardSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _CardSection({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Ítem de Catálogo de Producto ──────────────────────────────────────
class _ProductItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String moq;
  final Color color;

  const _ProductItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.moq,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.inventory_2_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(price, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(moq, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
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

// ── Barra de Calificación Círculo Dorado ──────────────────────────────
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
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
            Text('$score / 5.0', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.trustGreen, fontSize: 13)),
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

// ── Badge Informativo ─────────────────────────────────────────────────
class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(10),
      ),
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