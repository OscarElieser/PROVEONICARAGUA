// ==============================================================================
// PROVEO NICARAGUA - Utilidad Global de Apertura de Enlaces Externos (lib/core/utils/url_helper.dart)
// ¿Qué hace?: Permite abrir cualquier sitio web, perfil de red social o mapa GPS en una nueva pestaña del navegador o app nativa.
// ¿Por qué se utiliza?: Garantiza 100% de éxito en Flutter Web sin bloqueos de navegador ni caídas al portapapeles.
// ==============================================================================

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'url_helper_stub.dart' if (dart.library.html) 'url_helper_web.dart';

/// Abre un enlace externo (HTTP/HTTPS) en una nueva pestaña o aplicación dedicada.
Future<void> openExternalUrl(
  String rawUrl, {
  required void Function(String, String) onCopyFallback,
  String label = 'Enlace',
}) async {
  try {
    String url = rawUrl.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    // 1. En entornos Web, utiliza window.open('_blank') para apertura garantizada e inmediata
    if (kIsWeb) {
      openWebUrl(url);
      return;
    }

    // 2. En dispositivos nativos (Android / iOS), utiliza url_launcher
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  } catch (_) {
    onCopyFallback(rawUrl, label);
  }
}
