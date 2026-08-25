// ==============================================================================
// PROVEO NICARAGUA - Gestor de Estado de Autenticación (lib/core/providers/auth_provider.dart)
// ¿Qué hace?: Administra el ciclo de vida de la sesión (login, registro, OAuth Google, modo invitado, logout) y notifica cambios a la UI.
// ¿Por qué se utiliza?: Centraliza la autenticación reactiva con ChangeNotifierProvider desacoplando la UI del backend.
// ==============================================================================

// Importa los tipos de excepciones nativas de Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';

// Importa los componentes base de Flutter (ChangeNotifier, BuildContext)
import 'package:flutter/material.dart';

// Importa los modelos AuthUser y UserRole
import '../../models/models.dart';

// Importa el contrato de interfaz abstracta del repositorio de autenticación
import '../../services/auth/auth_repository.dart';

// Importa la implementación de autenticación sobre Firebase Auth
import '../../services/auth/firebase_auth_repository.dart';

// Importa el servicio global de Firebase para verificar inicialización
import '../../services/firebase/firebase_service.dart';

/// Enumerador que define los estados posibles del flujo de autenticación.
enum AuthState {
  /// Estado en reposo, listo para recibir interacciones del usuario.
  initial,

  /// Operación asíncrona en progreso (muestra spinners de carga).
  loading,

  /// Sesión iniciada con éxito y usuario verificado.
  authenticated,

  /// Fallo durante la autenticación (muestra banner o modal de error).
  error,
}

/// Provider global que administra la sesión del usuario mediante [ChangeNotifier].
class AuthProvider extends ChangeNotifier {
  /// Repositorio inyectado que abstrae las llamadas a Firebase o Mocks.
  final AuthRepository _authRepository;

  /// Estado interno actual de la autenticación.
  AuthState _state = AuthState.initial;

  /// Mensaje de error legible en español cuando ocurre una falla.
  String? _errorMessage;

  /// Datos del usuario con sesión activa en Proveo.
  AuthUser? _currentUser;

  /// Constructor con inyección de dependencias opcional (permite pruebas unitarias o fallback automático).
  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            (FirebaseService.isInitialized
                ? FirebaseAuthRepository()
                : MockAuthRepository());

  // --------------------------------------------------------------------------
  // GETTERS PÚBLICOS PARA CONSUMO DE LA UI
  // --------------------------------------------------------------------------

  /// Retorna el estado actual del flujo.
  AuthState get state => _state;

  /// Retorna el mensaje de error pendiente o null si todo está en orden.
  String? get errorMessage => _errorMessage;

  /// Retorna la información del usuario autenticado actual.
  AuthUser? get currentUser => _currentUser;

  /// Indica si hay una petición de red en curso para bloquear botones y mostrar spinners.
  bool get isLoading => _state == AuthState.loading;

  /// Indica si el usuario tiene una sesión activa y válida en la app.
  bool get isAuthenticated => _state == AuthState.authenticated && _currentUser != null;

  // --------------------------------------------------------------------------
  // MUTADORES DE ESTADO INTERNO (Notifican a los widgets escuchadores)
  // --------------------------------------------------------------------------

  /// Coloca el estado en 'loading' y limpia errores previos.
  void _setLoading() {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners(); // Notifica a los widgets suscritos (Consumer / context.watch)
  }

  /// Coloca el estado en 'error' con un mensaje descriptivo.
  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners(); // Notifica a la interfaz para desplegar alertas
  }

  /// Actualiza la sesión con el usuario autenticado exitosamente.
  void _setAuthenticated(AuthUser user) {
    _state = AuthState.authenticated;
    _currentUser = user;
    _errorMessage = null;
    notifyListeners(); // Provoca la reconstrucción hacia la vista principal (AppShell)
  }

  /// Restablece el estado al valor inicial tras cerrar sesión.
  void _resetState() {
    _state = AuthState.initial;
    _errorMessage = null;
    _currentUser = null;
    notifyListeners(); // Redirige a la pantalla de AuthScreen
  }

  // --------------------------------------------------------------------------
  // OPERACIONES DE AUTENTICACIÓN
  // --------------------------------------------------------------------------

  /// Inicia sesión con correo electrónico y contraseña.
  Future<void> signIn(String email, String password) async {
    _setLoading();
    try {
      // Solicita al repositorio la validación de credenciales
      final user = await _authRepository.signIn(email, password);
      // Registra al usuario autenticado
      _setAuthenticated(user);
    } on FirebaseAuthException catch (error) {
      // Mapea códigos de error específicos de Firebase a mensajes amigables en español
      _setError(_friendlyError(error.code));
    } on FirebaseException catch (error) {
      // Captura excepciones genéricas de Firebase
      _setError('Firebase: ${error.message ?? error.code}');
    } catch (_) {
      // Fallback ante excepciones inesperadas
      _setError('No pudimos iniciar sesión. Intenta nuevamente.');
    }
  }

  /// Registra una nueva cuenta de usuario asignando su rol inicial.
  Future<void> signUp(String email, String password, String name, UserRole role) async {
    _setLoading();
    try {
      // Crea el usuario en Firebase Authentication y su perfil en Firestore
      final user = await _authRepository.signUp(email, password, name, role);
      _setAuthenticated(user);
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error.code));
    } on FirebaseException catch (error) {
      _setError('Firebase: ${error.message ?? error.code}');
    } catch (_) {
      _setError('No pudimos crear tu cuenta. Intenta nuevamente.');
    }
  }

  /// Ejecuta el flujo de inicio de sesión con cuenta de Google (OAuth2).
  Future<void> signInWithGoogle() async {
    _setLoading();
    try {
      final user = await _authRepository.signInWithGoogle();
      _setAuthenticated(user);
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error.code));
    } on FirebaseException catch (error) {
      _setError('Firebase: ${error.message ?? error.code}');
    } catch (_) {
      _setError('No pudimos iniciar sesión con Google. Intenta nuevamente.');
    }
  }

  /// Permite la navegación en modo invitado para explorar el catálogo y proveedores sin registrarse previamente.
  Future<void> startGuestVisit() async {
    _setLoading();
    // Simula una breve transición fluida para feedback visual del usuario
    await Future.delayed(const Duration(milliseconds: 350));
    // Crea una identidad temporal de invitado con rol de emprendedor
    const guestUser = AuthUser(
      id: 'guest_session',
      name: 'Visitante Invitado',
      email: 'invitado@proveo.ni',
      role: UserRole.entrepreneur,
    );
    _setAuthenticated(guestUser);
  }

  /// Cierra la sesión activa en el repositorio y restablece el estado local.
  Future<void> signOut() async {
    _setLoading();
    try {
      // Solo invoca el cierre de sesión en Firebase si no es una sesión simulada de invitado
      if (_currentUser?.id != 'guest_session') {
        await _authRepository.signOut();
      }
      _resetState();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    }
  }

  /// Traduce los códigos de error técnicos de Firebase Auth a explicaciones comprensibles para el usuario final.
  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'El correo o la contraseña no son correctos.';
      case 'invalid-email':
        return 'Escribe un correo electrónico válido.';
      case 'unauthorized-domain':
        return 'Este dominio no está autorizado en Firebase. Agrega localhost en Authentication > Settings > Authorized domains.';
      case 'operation-not-allowed':
        return 'Google Sign-In no está habilitado en Firebase Authentication.';
      case 'popup-blocked':
        return 'El navegador bloqueó la ventana de Google. Permite ventanas emergentes para esta aplicación.';
      case 'popup-closed-by-user':
        return 'La ventana de Google se cerró antes de completar el acceso.';
      case 'network-request-failed':
        return 'No hay conexión con Firebase. Revisa tu red e inténtalo de nuevo.';
      default:
        return 'No pudimos iniciar sesión. Revisa tu conexión e inténtalo de nuevo.';
    }
  }

  /// Limpia manualmente el mensaje de error activo al cambiar de pestaña o reintentar.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}