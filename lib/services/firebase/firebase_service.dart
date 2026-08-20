import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Inicializacion central de Firebase.
///
/// Inicializa los servicios Firebase necesarios para producción.
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  static FirebaseAnalytics? get analytics => _analytics;
  static bool get isInitialized => _initialized;
  // Conecta a la base de datos 'proveodb' creada en Firebase Console
  static FirebaseFirestore get firestore {
    try {
      return FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'proveodb');
    } catch (_) {
      return FirebaseFirestore.instance;
    }
  }

  static Future<bool> initialize() async {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      // Solo inicializar si las opciones son validas (no es una plataforma no configurada)
      if (options.projectId.isEmpty) return false;
      if (Firebase.apps.isEmpty) await Firebase.initializeApp(options: options);
      if (Firebase.apps.isEmpty) return false;
      _initialized = true;
      
      // Activa Firebase App Check (utilizará el token de depuración declarado en index.html en desarrollo web)
      try {
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider('6Ld_placeholder'), // Se complementa con self.FIREBASE_APPCHECK_DEBUG_TOKEN
          androidProvider: AndroidProvider.debug,
          appleProvider: AppleProvider.debug,
        );
      } catch (e) {
        debugPrint('App Check Info: $e');
      }

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
