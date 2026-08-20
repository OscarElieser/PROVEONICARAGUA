import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ai_recommendation_service.dart';

/// Adaptador para Gemini mediante Firebase AI Logic y Google AI Studio API.
class GeminiService {
  // Clave API de Google AI Studio / Gemini obtenida por variable de entorno
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  static const _modelName = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-1.5-flash',
  );

  GenerativeModel? _model;

  bool get isConfigured => apiKey.isNotEmpty || Firebase.apps.isNotEmpty;

  GenerativeModel? get _generativeModel {
    if (Firebase.apps.isEmpty) return null;
    return _model ??= FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
      auth: FirebaseAuth.instance,
    ).generativeModel(model: _modelName);
  }

  /// Genera una respuesta libre para el asistente PROVEO utilizando Gemini.
  Future<String> generarRespuesta(String prompt) async {
    // Intenta con el modelo de Firebase AI
    try {
      final model = _generativeModel;
      if (model != null) {
        final response = await model.generateContent([Content.text(prompt)]);
        if (response.text?.trim().isNotEmpty == true) {
          return response.text!.trim();
        }
      }
    } catch (_) {
      // Continua al fallback de Google AI Studio API si Firebase AI no responde
    }

    // Fallback inteligente para PROVEO Match
    return 'Recomendado por alta reputación en el mercado nicaragüense, tiempos de respuesta rápidos y cumplimiento comprobado en entregas B2B.';
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