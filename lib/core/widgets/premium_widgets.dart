import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const PremiumCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.onTap});
  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0A002049), blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: child,
    );
    return onTap == null ? card : InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: card);
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMore;
  const SectionTitle({super.key, required this.title, this.subtitle, this.onMore});
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary))],
      ])),
      if (onMore != null) TextButton(onPressed: onMore, child: const Text('Ver todo')),
    ],
  );
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color accent;
  const StatCard({super.key, required this.value, required this.label, required this.icon, this.accent = AppColors.navy});
  @override
  Widget build(BuildContext context) => PremiumCard(child: Row(children: [
    Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withValues(alpha: .10), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: accent)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)), Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]))
  ]));
}

class VerifiedBadge extends StatelessWidget {
  final String text;
  const VerifiedBadge({super.key, this.text = 'Proveedor verificado'});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(color: AppColors.paleGreen, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.verified, size: 14, color: AppColors.trustGreen), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, color: AppColors.trustGreen, fontWeight: FontWeight.w700))]),
  );
}

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});
  @override
  Widget build(BuildContext context) => Row(children: [
    ...List.generate(5, (i) => Icon(i < rating.round() ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.warning, size: 17)),
    const SizedBox(width: 4), Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
  ]);
}
