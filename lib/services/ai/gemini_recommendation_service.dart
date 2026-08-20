import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ai_recommendation_service.dart';

/// Adaptador para Gemini mediante Firebase AI Logic.
class GeminiService {
  static const _modelName = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-1.5-flash-latest',
  );

  GenerativeModel? _model;

  bool get isConfigured => Firebase.apps.isNotEmpty;

  GenerativeModel? get _generativeModel {
    if (!isConfigured) return null;
    return _model ??= FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
      auth: FirebaseAuth.instance,
    ).generativeModel(model: _modelName);
  }

  /// Genera una respuesta libre para el asistente PROVEO.
  Future<String> generarRespuesta(String prompt) async {
    final model = _generativeModel;
    if (model == null) return 'La IA no está configurada. Usando recomendaciones PROVEO.';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim().isNotEmpty == true
          ? response.text!.trim()
          : 'No se obtuvo una respuesta.';
    } on FirebaseAIException {
      return 'No pudimos consultar la IA en este momento.';
    }
  }
}

/// Servicio especializado para explicar las recomendaciones de PROVEO.
class GeminiRecommendationService extends GeminiService {

  Future<String> explain({required List<RecommendationResult> results, required String request}) async {
    if (!isConfigured) return _fallback(results);
    final providers = results.map((result) => '${result.provider.name}: ${result.score}%').join(', ');
    final prompt = 'Eres el asistente B2B de PROVEO. Explica en español, en máximo 3 frases, por qué estas opciones coinciden con la solicitud "$request": $providers. No inventes datos.';
    final response = await generarRespuesta(prompt);
    return response.startsWith('No pudimos consultar') || response.startsWith('La IA no está configurada')
        ? _fallback(results)
        : response;
  }

  String _fallback(List<RecommendationResult> results) => results.isEmpty ? 'No encontramos proveedores con esos criterios.' : results.first.explanation;
}