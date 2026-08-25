// ==============================================================================
// PROVEO NICARAGUA - Biblioteca de Widgets de UI Reutilizables (lib/core/widgets/premium_widgets.dart)
// ¿Qué hace?: Contiene componentes modulares de diseño (Tarjetas premium, títulos de sección, insignias de verificación, estrellas y métricas).
// ¿Por qué se utiliza?: Evita duplicación de código en vistas y garantiza fidelidad con el sistema de diseño de Proveo.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../theme/app_colors.dart';

/// Tarjeta estilizada con bordes redondeados (18px), sombra sutil y soporte táctil opcional con efecto ripple.
class PremiumCard extends StatelessWidget {
  /// Widget contenido dentro del cuerpo de la tarjeta
  final Widget child;

  /// Relleno interno (padding) de la tarjeta
  final EdgeInsetsGeometry padding;

  /// Callback opcional que habilita la interacción al hacer clic / tap
  final VoidCallback? onTap;

  /// Constructor constante
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Contenedor decorado con borde fino y sombra difusa
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface, // Fondo blanco puro
        borderRadius: BorderRadius.circular(18), // Curvatura en esquinas
        border: Border.all(color: AppColors.border), // Borde perimetral neutro
        boxShadow: const [
          // Sombra ambiental suave en azul profundo
          BoxShadow(
            color: Color(0x0A002049),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    // Si no tiene onTap retorna el contenedor estático; si tiene onTap añade InkWell para feedback táctil
    return onTap == null
        ? card
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: card,
          );
  }
}

/// Encabezado estandarizado para separar secciones de contenido con título, subtítulo y botón de acción ("Ver todo").
class SectionTitle extends StatelessWidget {
  /// Título principal de la sección
  final String title;

  /// Descripción secundaria explicativa opcional
  final String? subtitle;

  /// Callback para el botón de navegación a la vista completa
  final VoidCallback? onMore;

  /// Constructor constante
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Columna con los textos jerarquizados
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          // Botón de acción si se proporcionó un callback
          if (onMore != null)
            TextButton(
              onPressed: onMore,
              child: const Text('Ver todo'),
            ),
        ],
      );
}

/// Tarjeta de métrica o estadística clave para dashboards y resúmenes ejecutivos.
class StatCard extends StatelessWidget {
  /// Valor cuantitativo destacado (ej: "128", "C\$ 45,000", "98%")
  final String value;

  /// Etiqueta explicativa inferior (ej: "Cotizaciones activas")
  final String label;

  /// Icono ilustrativo de la métrica
  final IconData icon;

  /// Color de acento para el icono y su fondo tintado
  final Color accent;

  /// Constructor constante
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.accent = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) => PremiumCard(
        child: Row(
          children: [
            // Contenedor del icono con fondo semi-transparente del color de acento
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            // Textos de valor y etiqueta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Insignia verde con icono de check que certifica que un proveedor ha sido verificado legal y físicamente por Proveo.
class VerifiedBadge extends StatelessWidget {
  /// Texto de la insignia
  final String text;

  /// Constructor constante
  const VerifiedBadge({
    super.key,
    this.text = 'Proveedor verificado',
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.paleGreen, // Fondo verde claro
          borderRadius: BorderRadius.circular(20), // Forma de píldora (pill)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, size: 14, color: AppColors.trustGreen),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.trustGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}

/// Calificación visual con 5 estrellas doradas y el puntaje numérico con un decimal.
class RatingStars extends StatelessWidget {
  /// Calificación de 0.0 a 5.0
  final double rating;

  /// Constructor constante
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Genera 5 iconos de estrella rellenando las alcanzadas
          ...List.generate(
            5,
            (i) => Icon(
              i < rating.round()
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: AppColors.warning,
              size: 17,
            ),
          ),
          const SizedBox(width: 4),
          // Valor numérico en negrita
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
}

