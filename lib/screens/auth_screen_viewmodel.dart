import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../services/firebase/firebase_service.dart';

/// Define los posibles estados de la pantalla de autenticación.
enum AuthState {
  initial,
  loading,
  authenticated,
  error,
}

/// ViewModel para gestionar el estado y la lógica de autenticación en `AuthScreen`.
class AuthScreenViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  AuthUser? _currentUser;

  AuthScreenViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            (FirebaseService.isInitialized
                ? FirebaseAuthRepository()
                : MockAuthRepository());

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _state == AuthState.loading;

  /// Establece el estado a cargando y limpia cualquier error previo.
  void _setLoading() {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  /// Establece el estado a error con un mensaje específico.
  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Establece el estado a autenticado con el usuario actual.
  void _setAuthenticated(AuthUser user) {
    _state = AuthState.authenticated;
    _currentUser = user;
    _errorMessage = null;
    notifyListeners();
  }

  /// Restablece el estado a inicial, útil después de cerrar sesión.
  void _resetState() {
    _state = AuthState.initial;
    _errorMessage = null;
    _currentUser = null;
    notifyListeners();
  }

  /// Intenta iniciar sesión con correo y contraseña.
  Future<void> signIn(String email, String password) async {
    _setLoading();
    try {
      final user = await _authRepository.signIn(email, password);
      _setAuthenticated(user);
    } on FirebaseAuthException catch (error) {
      _setError(_friendlyError(error.code));
    } on FirebaseException catch (error) {
      _setError('Firebase: ${error.message ?? error.code}');
    } catch (_) {
      _setError('No pudimos iniciar sesión. Intenta nuevamente.');
    }
  }

  /// Intenta iniciar sesión con Google.
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

  /// Cierra la sesión del usuario.
  Future<void> signOut() async {
    _setLoading(); // Opcional: mostrar carga mientras se cierra sesión
    try {
      await _authRepository.signOut();
      _resetState(); // Restablece el estado después de cerrar sesión
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    }
  }

  /// Mapea códigos de error de Firebase a mensajes amigables para el usuario.
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

  /// Limpia el mensaje de error actual.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}