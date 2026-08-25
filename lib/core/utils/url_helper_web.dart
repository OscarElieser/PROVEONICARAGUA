// ==============================================================================
// PROVEO NICARAGUA - Implementación Web para Apertura de Enlaces (lib/core/utils/url_helper_web.dart)
// ==============================================================================

// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Abre un enlace externo directamente en una pestaña nueva usando la API nativa del navegador (html.window.open)
void openWebUrl(String url) {
  html.window.open(url, '_blank');
}
