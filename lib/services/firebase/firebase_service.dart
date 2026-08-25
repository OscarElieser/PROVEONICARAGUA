// ==============================================================================
// PROVEO NICARAGUA - Núcleo de Servicios Firebase (lib/services/firebase/firebase_service.dart)
// ¿Qué hace?: Centraliza la inicialización de Firebase, conexión a la base de datos 'proveodb', activación de App Check y Google Analytics.
// ¿Por qué se utiliza?: Asegura un punto único de arranque e inyección segura para todos los servicios de Google Cloud en Proveo.
// ==============================================================================

// Importa el cliente de analíticas de Firebase para métricas de comportamiento
import 'package:firebase_analytics/firebase_analytics.dart';

// Importa el servicio de protección de integridad y anti-abuso App Check
import 'package:firebase_app_check/firebase_app_check.dart';

// Importa el inicializador central de Firebase
import 'package:firebase_core/firebase_core.dart';

// Importa la instancia de Cloud Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Importa herramientas de depuración de Flutter
import 'package:flutter/foundation.dart';

// Importa las opciones de conexión generadas de Proveo Nicaragua
import '../../firebase_options.dart';

/// Servicio singleton/estático responsable de la inicialización y acceso a las instancias de Firebase.
class FirebaseService {
  /// Instancia de Google Analytics para registrar eventos de usuario
  static FirebaseAnalytics? _analytics;

  /// Bandera booleana que indica si Firebase completó su arranque exitosamente
  static bool _initialized = false;

  /// Getter público para acceder a la instancia de Analytics
  static FirebaseAnalytics? get analytics => _analytics;

  /// Getter público que expone si el backend de Firebase está listo para usarse
  static bool get isInitialized => _initialized;

  /// Provee la instancia de Cloud Firestore conectada a la base de datos nombrada 'proveodb'
  static FirebaseFirestore get firestore {
    try {
      // Conecta explícitamente a la base de datos dedicada 'proveodb' en la consola de Firebase
      return FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'proveodb',
      );
    } catch (_) {
      // Fallback a la base de datos por defecto (default) si hay discrepancia de configuración
      return FirebaseFirestore.instance;
    }
  }

  /// Ejecuta la inicialización secuencial de Firebase, App Check y Analytics con manejo seguro de fallos.
  static Future<bool> initialize() async {
    try {
      // Obtiene las opciones de Firebase para la plataforma actual
      final options = DefaultFirebaseOptions.currentPlatform;

      // Si el proyecto no tiene credenciales configuradas para esta plataforma, aborta limpiamente
      if (options.projectId.isEmpty) return false;

      // Inicializa Firebase si no existe una aplicación previa registrada
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }

      // Valida que exista al menos una app activa tras la inicialización
      if (Firebase.apps.isEmpty) return false;

      _initialized = true;
      
      // Activa Firebase App Check para proteger cuotas de API y endpoints contra bots
      try {
        await FirebaseAppCheck.instance.activate(
          // Proveedor ReCaptcha V3 para la versión web
          webProvider: ReCaptchaV3Provider('6Ld_placeholder'),
          // Proveedor de depuración para desarrollo en Android
          androidProvider: AndroidProvider.debug,
          // Proveedor de depuración para desarrollo en iOS/macOS
          appleProvider: AppleProvider.debug,
        );
      } catch (e) {
        // Registra el estado de App Check en modo desarrollo sin detener la app
        debugPrint('App Check Info: $e');
      }

      // Inicializa y registra el primer evento de apertura de la aplicación en Analytics
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.logAppOpen();

      return true;
    } on UnsupportedError {
      _initialized = false;
      return false;
    } on FirebaseException {
      _initialized = false;
      return false;
    }
  }
}

