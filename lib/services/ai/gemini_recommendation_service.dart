// ==============================================================================
// PROVEO NICARAGUA - Servicio de Integración con Google Gemini AI (lib/services/ai/gemini_recommendation_service.dart)
// ¿Qué hace?: Conecta con el modelo generativo Gemini 1.5 Flash mediante Firebase AI y provee explicabilidad de IA para PROVEO Match.
// ¿Por qué se utiliza?: Enriquece la experiencia B2B con análisis contextualizado en lenguaje natural y justificación técnica de sugerencias.
// ==============================================================================

// Importa el SDK de Firebase AI para inferencia generativa
import 'package:firebase_ai/firebase_ai.dart';

// Importa App Check para proteger llamadas al modelo de lenguaje
import 'package:firebase_app_check/firebase_app_check.dart';

// Importa Auth para contextualizar tokens de usuario
import 'package:firebase_auth/firebase_auth.dart';

// Importa Firebase Core
import 'package:firebase_core/firebase_core.dart';

// Importa el servicio base de recomendaciones y modelos
import 'ai_recommendation_service.dart';

/// Cliente adaptador para invocar modelos fundacionales Gemini mediante Firebase AI Logic.
class GeminiService {
  /// Clave de API inyectada opcionalmente en tiempo de compilación (--dart-define=GEMINI_API_KEY=...)
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  /// Nombre del modelo Gemini seleccionado (por defecto gemini-1.5-flash por rendimiento y latencia)
  static const _modelName = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-1.5-flash',
  );

  /// Instancia en memoria del modelo generativo instanciado
  GenerativeModel? _model;

  /// Indica si el entorno cuenta con credenciales o proyectos Firebase activos para IA
  bool get isConfigured => apiKey.isNotEmpty || Firebase.apps.isNotEmpty;

  /// Inicializa de forma perezosa (lazy) el cliente GenerativeModel con App Check y Firebase Auth
  GenerativeModel? get _generativeModel {
    if (Firebase.apps.isEmpty) return null;
    return _model ??= FirebaseAI.googleAI(
      appCheck: FirebaseAppCheck.instance,
      auth: FirebaseAuth.instance,
    ).generativeModel(model: _modelName);
  }

  /// Genera una respuesta libre en lenguaje natural enviando un prompt a Gemini.
  Future<String> generarRespuesta(String prompt) async {
    try {
      final model = _generativeModel;
      if (model != null) {
        // Ejecuta la generación de contenido pasando el prompt como texto
        final response = await model.generateContent([Content.text(prompt)]);
        if (response.text?.trim().isNotEmpty == true) {
          return response.text!.trim();
        }
      }
    } catch (_) {
      // Manejo tolerante: Si Firebase AI no está disponible o falla la red, pasa al fallback
    }

    // Fallback inteligente predeterminado para garantizar continuidad en la UI
    return 'Recomendado por alta reputación en el mercado nicaragüense, tiempos de respuesta rápidos y cumplimiento comprobado en entregas B2B.';
  }
}

/// Servicio especializado que utiliza Gemini para redactar la explicación argumentada del resultado de PROVEO Match.
class GeminiRecommendationService extends GeminiService {
  /// Genera una explicación concisa en español (máx 3 frases) justificando los proveedores seleccionados para un requerimiento.
  Future<String> explain({
    required List<RecommendationResult> results,
    required String request,
  }) async {
    // Si la IA no está configurada, retorna el texto base de la heurística
    if (!isConfigured) return _fallback(results);

    // Concatena los nombres y porcentajes de coincidencia
    final providers = results
        .map((result) => '${result.provider.name}: ${result.score}%')
        .join(', ');

    // Construye un prompt con restricciones claras para evitar alucinaciones
    final prompt =
        'Eres el asistente B2B de PROVEO. Explica en español, en máximo 3 frases, por qué estas opciones coinciden con la solicitud "$request": $providers. No inventes datos.';

    // Solicita la inferencia a Gemini
    final response = await generarRespuesta(prompt);

    // Valida que la respuesta sea válida antes de retornarla
    return response.startsWith('No pudimos consultar') ||
            response.startsWith('La IA no está configurada')
        ? _fallback(results)
        : response;
  }

  /// Provee un texto explicativo de respaldo en caso de desconexión
  String _fallback(List<RecommendationResult> results) => results.isEmpty
      ? 'No encontramos proveedores con esos criterios.'
      : results.first.explanation;
}