// ==============================================================================
// PROVEO NICARAGUA - Componente Gráfico del Logotipo Oficial (lib/core/widgets/proveo_logo.dart)
// ¿Qué hace?: Renderiza el isotipo y logotipo oficial vectorial (SVG) de Proveo con soporte de escalabilidad y accesibilidad.
// ¿Por qué se utiliza?: Centraliza la identidad de marca oficial, garantizando nitidez perfecta en cualquier resolución.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// Variantes visuales del logotipo oficial de PROVEO disponibles en el proyecto.
enum ProveoLogoVariant {
  /// Logotipo completo con isotipo, nombre PROVEO y lema comercial (logo1.svg)
  full,

  /// Logotipo extendido con isotipo en degradado rico y lema doble (logo2.svg)
  extended,

  /// Únicamente el isotipo geométrico con degradado corporativo (logo3.svg)
  iconOnly,

  /// Disposición horizontal ideal para barras de navegación: Isotipo (logo3.svg) + Tipografía PROVEO
  horizontal,
}

/// Widget reutilizable que encapsula el logotipo vectorial oficial de PROVEO Nicaragua.
class ProveoLogo extends StatelessWidget {
  /// Altura visual del logotipo en píxeles lógicos
  final double height;

  /// Ancho opcional del logotipo en píxeles lógicos
  final double? width;

  /// Variante de visualización del logotipo
  final ProveoLogoVariant variant;

  /// Indica si el logotipo se renderiza sobre un fondo oscuro (para ajustar contraste tipográfico)
  final bool isDarkBackground;

  /// Ajuste de escalado de la imagen
  final BoxFit fit;

  /// Acción opcional al presionar el logotipo
  final VoidCallback? onTap;

  /// Subtítulo opcional para la variante horizontal (ej. "NICARAGUA" o "B2B")
  final String? subtitle;

  /// Constructor principal con soporte completo de variantes y escalabilidad
  const ProveoLogo({
    super.key,
    this.height = 52,
    this.width,
    this.variant = ProveoLogoVariant.full,
    this.isDarkBackground = false,
    this.fit = BoxFit.contain,
    this.onTap,
    this.subtitle,
  });

  /// Constructor de conveniencia para la barra de navegación horizontal
  const ProveoLogo.horizontal({
    super.key,
    this.height = 42,
    this.width,
    this.isDarkBackground = false,
    this.fit = BoxFit.contain,
    this.onTap,
    this.subtitle = 'NICARAGUA',
  }) : variant = ProveoLogoVariant.horizontal;

  /// Constructor de conveniencia para el isotipo aislado
  const ProveoLogo.iconOnly({
    super.key,
    this.height = 40,
    this.width,
    this.isDarkBackground = false,
    this.fit = BoxFit.contain,
    this.onTap,
    this.subtitle,
  }) : variant = ProveoLogoVariant.iconOnly;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (variant) {
      case ProveoLogoVariant.full:
        content = SvgPicture.asset(
          'assets/logo/logo1.svg',
          height: height,
          width: width,
          fit: fit,
          semanticsLabel: 'Logotipo oficial de PROVEO Nicaragua',
        );
        break;

      case ProveoLogoVariant.extended:
        content = SvgPicture.asset(
          'assets/logo/logo2.svg',
          height: height,
          width: width,
          fit: fit,
          semanticsLabel: 'Logotipo extendido oficial de PROVEO Nicaragua',
        );
        break;

      case ProveoLogoVariant.iconOnly:
        content = SvgPicture.asset(
          'assets/logo/logo3.svg',
          height: height,
          width: width ?? height,
          fit: fit,
          semanticsLabel: 'Isotipo oficial de PROVEO Nicaragua',
        );
        break;

      case ProveoLogoVariant.horizontal:
        final textColor = isDarkBackground ? Colors.white : AppColors.navy;
        final subColor = isDarkBackground ? AppColors.trustGreen : AppColors.teal;
        final iconSize = height;

        content = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Isotipo vectorial oficial (logo3.svg)
            SvgPicture.asset(
              'assets/logo/logo3.svg',
              height: iconSize,
              width: iconSize,
              fit: BoxFit.contain,
              semanticsLabel: 'Isotipo PROVEO',
            ),
            const SizedBox(width: 10),
            // Bloque tipográfico de la marca
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROVEO',
                  style: TextStyle(
                    color: textColor,
                    fontSize: height * 0.52,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                    height: 1.0,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: subColor,
                      fontSize: (height * 0.22).clamp(9.0, 13.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                      height: 1.0,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
        break;
    }

    if (onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      );
    }

    return Semantics(
      label: 'Logotipo oficial de PROVEO Nicaragua',
      image: true,
      child: content,
    );
  }
}
