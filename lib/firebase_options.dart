// ==============================================================================
// PROVEO NICARAGUA - Opciones de Configuración Firebase (firebase_options.dart)
// ¿Qué hace?: Provee las credenciales y parámetros de conexión específicos para los servicios de Firebase en la web.
// ¿Por qué se utiliza?: Permite inicializar Firebase.initializeApp() con las llaves autorizadas de Proveo Nicaragua.
// ==============================================================================

// ignore_for_file: type=lint

// Importa el contenedor de opciones oficial del SDK de Firebase
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Importa herramientas de detección de plataforma en tiempo de ejecución (Web vs Nativo)
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Clase utilitaria que provee las opciones de Firebase adecuadas según la plataforma de ejecución.
class DefaultFirebaseOptions {
  /// Obtiene la configuración de Firebase correspondiente al entorno actual (Web o fallback nativo).
  ///
  /// Retorna [web] si se ejecuta en navegador/PWA o [_emptyOptions] como fallback seguro.
  static FirebaseOptions get currentPlatform {
    // Si la aplicación se está ejecutando en navegador web (Flutter Web)
    if (kIsWeb) {
      // Retorna las credenciales oficiales de la consola de Firebase Web
      return web;
    }
    
    // Evalúa la plataforma de escritorio o móvil subyacente
    switch (defaultTargetPlatform) {
      // Para plataformas nativas en desarrollo donde se utilizan servicios mock / simulados
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        // Devuelve configuración vacía controlada para evitar cierres inesperados (crashes)
        return _emptyOptions;
      default:
        // Lanza error explicativo si la plataforma no está soportada en absoluto
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Credenciales oficiales del proyecto Firebase de PROVEO Nicaragua para Web / PWA.
  static const FirebaseOptions web = FirebaseOptions(
    // Clave de API pública de Firebase para identificar peticiones autorizadas
    apiKey: 'AIzaSyCIQif5gmNmFvaiMmt32HQsUFMeUQ-mz8Q',
    // Identificador único de la aplicación Web registrada en el proyecto Firebase
    appId: '1:248254644384:web:ff90463639b6319ccd89c5',
    // ID numérico del remitente para notificaciones push (Cloud Messaging)
    messagingSenderId: '248254644384',
    // Nombre canónico del proyecto en Google Cloud / Firebase Console
    projectId: 'proveonicaragua-43264',
    // Dominio OAuth autorizado para redirigir flujos de inicio de sesión seguros
    authDomain: 'proveonicaragua-43264.firebaseapp.com',
    // Bucket de Cloud Storage para almacenar imágenes y catálogos de proveedores
    storageBucket: 'proveonicaragua-43264.firebasestorage.app',
    // ID de flujo de Google Analytics para métricas de tráfico y conversiones
    measurementId: 'G-290ZBZ2YWZ',
  );

  /// Configuración neutra para plataformas secundarias sin backend directo configurado.
  static const FirebaseOptions _emptyOptions = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
  );
}

