import '../../models/models.dart';

/// Resultado explicable de PROVEO Match.
class RecommendationResult {
  final ProviderModel provider;
  final int score;
  final String explanation;

  const RecommendationResult({required this.provider, required this.score, required this.explanation});
}

/// Motor inicial basado en reglas. La interfaz permite sustituirlo por Gemini
/// u otro proveedor sin acoplar la experiencia a una API externa.
class AIRecommendationService {
  final Map<String, double> weights;

  const AIRecommendationService({this.weights = const {'rating': .35, 'response': .25, 'distance': .20, 'experience': .20}});

  List<RecommendationResult> recommend({required String category, required List<ProviderModel> providers, String? location}) {
    final matches = providers.where((provider) => provider.category.toLowerCase().contains(category.toLowerCase()) || category.toLowerCase().contains('empaque')).toList();
    final ranked = matches.isEmpty ? providers : matches;
    return ranked.map((provider) {
      final score = (provider.rating / 5 * 70 + (provider.featured ? 10 : 0) + (provider.years.clamp(0, 20) / 20 * 10) + (provider.responseTime.startsWith('2') ? 10 : 5)).round().clamp(0, 99);
      return RecommendationResult(provider: provider, score: score, explanation: 'Recomendado por reputación, tiempo de respuesta y experiencia empresarial.');
    }).toList()..sort((a, b) => b.score.compareTo(a.score));
  }
}