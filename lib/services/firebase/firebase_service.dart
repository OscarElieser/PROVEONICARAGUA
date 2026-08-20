import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Inicializacion central de Firebase.
///
/// La aplicacion continua funcionando con MockData si la plataforma aun no
/// tiene opciones nativas generadas por FlutterFire.
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  static FirebaseAnalytics? get analytics => _analytics;
  static bool get isInitialized => _initialized;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static Future<bool> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _initialized = true;
      await _activateAppCheck();
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
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

  static Future<void> _activateAppCheck() async {
    if (String.fromEnvironment('FIREBASE_APPCHECK_ENABLED') != 'true') return;
    final appCheck = FirebaseAppCheck.instance;
    if (kIsWeb) {
      final siteKey = String.fromEnvironment('FIREBASE_APPCHECK_WEB_KEY');
      if (siteKey.isEmpty) return;
      await appCheck.activate(webProvider: ReCaptchaV3Provider(siteKey));
    } else {
      await appCheck.activate();
    }
  }
}