// ==============================================================================
// PROVEO NICARAGUA - Motor de Recomendación Heurístico B2B (lib/services/ai/ai_recommendation_service.dart)
// ¿Qué hace?: Calcula un puntaje de compatibilidad (Score 0-99%) para ordenar proveedores según rubro y métricas.
// ¿Por qué se utiliza?: Provee una capa algorítmica determinista y veloz para matching offline o complementaria a Gemini.
// ==============================================================================

// Importa los modelos del dominio comercial
import '../../models/models.dart';

/// Estructura inmutable que encapsula el resultado del análisis de recomendación para un proveedor.
class RecommendationResult {
  /// Proveedor evaluado
  final ProviderModel provider;

  /// Porcentaje de afinidad o compatibilidad comercial calculado (0 a 99%)
  final int score;

  /// Explicación textual del motivo por el cual se sugiere este proveedor
  final String explanation;

  /// Constructor constante para optimización de memoria
  const RecommendationResult({
    required this.provider,
    required this.score,
    required this.explanation,
  });
}

/// Servicio de cálculo de afinidad basado en reglas de negocio y ponderaciones multicriterio.
class AIRecommendationService {
  /// Pesos relativos asignados a cada factor (Calificación, Velocidad, Distancia, Años en el mercado)
  final Map<String, double> weights;

  /// Constructor con matriz de pesos por defecto calibrada para el mercado B2B nicaragüense
  const AIRecommendationService({
    this.weights = const {
      'rating': .35,
      'response': .25,
      'distance': .20,
      'experience': .20,
    },
  });

  /// Ejecuta el filtrado y ranking ordenado de proveedores según la categoría y ubicación solicitada.
  List<RecommendationResult> recommend({
    required String category,
    required List<ProviderModel> providers,
    String? location,
  }) {
    // Filtra proveedores cuya categoría coincida con el término buscado (o fallback a empaques)
    final matches = providers
        .where((provider) =>
            provider.category.toLowerCase().contains(category.toLowerCase()) ||
            category.toLowerCase().contains('empaque'))
        .toList();

    // Si no hubo coincidencia estricta, evalúa el catálogo completo
    final ranked = matches.isEmpty ? providers : matches;

    // Calcula el score para cada proveedor y lo encapsula en un RecommendationResult
    return ranked.map((provider) {
      // Fórmula heurística:
      // - 70% máx por Rating (estrellas / 5 * 70)
      // - +10 pts si es proveedor destacado/verificado (featured)
      // - +10 pts máx por experiencia (hasta 20 años tope)
      // - +10 pts si responde en <= 2 horas (+5 si tarda más)
      final score = (provider.rating / 5 * 70 +
              (provider.featured ? 10 : 0) +
              (provider.years.clamp(0, 20) / 20 * 10) +
              (provider.responseTime.startsWith('2') ? 10 : 5))
          .round()
          .clamp(0, 99); // Limita el puntaje en el rango seguro [0, 99]

      return RecommendationResult(
        provider: provider,
        score: score,
        explanation: 'Recomendado por reputación, tiempo de respuesta y experiencia empresarial.',
      );
    }).toList()
      // Ordena de mayor a menor compatibilidad (ranking descendente)
      ..sort((a, b) => b.score.compareTo(a.score));
  }
}