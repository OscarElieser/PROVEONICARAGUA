import '../../models/models.dart';
import 'gemini_recommendation_service.dart';

class CompanySourceSignal {
  final String name;
  final String label;
  final String url;
  final String status;

  const CompanySourceSignal({
    required this.name,
    required this.label,
    required this.url,
    required this.status,
  });
}

class CompanyIntelligenceReport {
  final String providerName;
  final int confidenceScore;
  final String summary;
  final List<String> strengths;
  final List<String> recommendedQuestions;
  final List<CompanySourceSignal> sources;

  const CompanyIntelligenceReport({
    required this.providerName,
    required this.confidenceScore,
    required this.summary,
    required this.strengths,
    required this.recommendedQuestions,
    required this.sources,
  });
}

class CompanyIntelligenceService {
  final GeminiService _geminiService;

  CompanyIntelligenceService({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService();

  Future<CompanyIntelligenceReport> buildReport({
    required ProviderModel provider,
    required String product,
    required String description,
    required String quantity,
    required String budget,
    required String deliveryLocation,
    required Iterable<String> requirements,
  }) async {
    final confidence = _confidenceFor(provider);
    final strengths = _strengthsFor(provider, requirements);
    final questions = _questionsFor(product, requirements);
    final sources = _sourcesFor(provider.name);
    final fallback = _fallbackSummary(
      provider: provider,
      product: product,
      quantity: quantity,
      confidence: confidence,
    );

    var summary = fallback;
    if (_geminiService.isConfigured) {
      final prompt = '''
Eres el analista de inteligencia comercial de PROVEO Nicaragua.
Analiza al proveedor "${provider.name}" como segundo recurso especial para una cotizacion B2B.

Datos internos PROVEO:
- Categoria: ${provider.category}
- Ubicacion: ${provider.location}
- Reputacion interna: ${provider.rating}/5 con ${provider.reviews} valoraciones
- Trayectoria: ${provider.years} anos
- Tiempo de respuesta: ${provider.responseTime}
- Requerimiento: $product
- Descripcion: $description
- Cantidad: $quantity
- Presupuesto: $budget
- Entrega: $deliveryLocation
- Requisitos: ${requirements.join(', ')}

Redacta en espanol sin inventar datos externos. Maximo 2 frases. Indica que las redes y Google deben verificarse con los accesos de busqueda cuando no haya API conectada.
''';
      final generated = await _geminiService.generarRespuesta(prompt);
      if (generated.trim().isNotEmpty) {
        summary = generated.trim();
      }
    }

    return CompanyIntelligenceReport(
      providerName: provider.name,
      confidenceScore: confidence,
      summary: summary,
      strengths: strengths,
      recommendedQuestions: questions,
      sources: sources,
    );
  }

  int _confidenceFor(ProviderModel provider) {
    final ratingScore = provider.rating / 5 * 48;
    final reviewsScore = provider.reviews.clamp(0, 150) / 150 * 18;
    final yearsScore = provider.years.clamp(0, 20) / 20 * 18;
    final responseScore = provider.responseTime.startsWith('1') || provider.responseTime.startsWith('2') ? 10 : 6;
    final featuredScore = provider.featured ? 6 : 0;
    return (ratingScore + reviewsScore + yearsScore + responseScore + featuredScore)
        .round()
        .clamp(55, 98)
        .toInt();
  }

  List<String> _strengthsFor(ProviderModel provider, Iterable<String> requirements) {
    final strengths = <String>[
      'Reputacion interna de ${provider.rating}/5 y ${provider.reviews} valoraciones en PROVEO.',
      '${provider.years} anos de trayectoria reportada para decisiones B2B con menor incertidumbre.',
      'Respuesta estimada en ${provider.responseTime}, util para cotizaciones con seguimiento rapido.',
    ];
    if (provider.featured) {
      strengths.insert(0, 'Proveedor destacado por PROVEO para solicitudes de alto valor.');
    }
    if (requirements.any((r) => r.toLowerCase().contains('alimentos') || r.toLowerCase().contains('bpa'))) {
      strengths.add('Conviene pedir ficha tecnica y declaracion de aptitud para contacto con alimentos.');
    }
    return strengths.take(4).toList();
  }

  List<String> _questionsFor(String product, Iterable<String> requirements) {
    final questions = <String>[
      'Confirmar MOQ, precio por escala y vigencia de la oferta para $product.',
      'Solicitar tiempos de produccion, despacho y penalidad por retraso.',
      'Pedir muestra fisica o ficha tecnica antes de emitir orden de compra.',
    ];
    if (requirements.isNotEmpty) {
      questions.add('Validar por escrito estos requisitos: ${requirements.join(', ')}.');
    }
    return questions.take(4).toList();
  }

  List<CompanySourceSignal> _sourcesFor(String providerName) {
    final query = Uri.encodeComponent('$providerName Nicaragua');
    return [
      CompanySourceSignal(
        name: 'Google',
        label: 'Buscar empresa, resenas y sitio oficial',
        url: 'https://www.google.com/search?q=$query',
        status: 'Busqueda abierta',
      ),
      CompanySourceSignal(
        name: 'Facebook',
        label: 'Validar actividad comercial y comentarios',
        url: 'https://www.facebook.com/search/top?q=$query',
        status: 'Red social',
      ),
      CompanySourceSignal(
        name: 'Instagram',
        label: 'Revisar catalogo visual y publicaciones recientes',
        url: 'https://www.instagram.com/explore/search/keyword/?q=$query',
        status: 'Red social',
      ),
      CompanySourceSignal(
        name: 'TikTok',
        label: 'Buscar videos, productos y presencia publica',
        url: 'https://www.tiktok.com/search?q=$query',
        status: 'Red social',
      ),
      CompanySourceSignal(
        name: 'YouTube',
        label: 'Buscar videos corporativos o demostraciones',
        url: 'https://www.youtube.com/results?search_query=$query',
        status: 'Video',
      ),
    ];
  }

  String _fallbackSummary({
    required ProviderModel provider,
    required String product,
    required String quantity,
    required int confidence,
  }) {
    return 'La IA posiciona a ${provider.name} con $confidence% de confianza para cotizar $quantity de $product, usando reputacion, trayectoria, respuesta y compatibilidad interna. Para fortalecer datos externos, abre las fuentes sugeridas y valida actividad reciente, comentarios, catalogo y datos de contacto antes de adjudicar.';
  }
}
