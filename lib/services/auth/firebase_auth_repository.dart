// ==============================================================================
// PROVEO NICARAGUA - Implementación Firebase de Autenticación (lib/services/auth/firebase_auth_repository.dart)
// ¿Qué hace?: Conecta los flujos de inicio de sesión, registro y OAuth Google con Firebase Auth y sincroniza roles en Firestore.
// ¿Por qué se utiliza?: Es la implementación productiva segura que maneja tokens JWT y persistencia de usuarios en la nube.
// ==============================================================================

// Importa el SDK de Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';

// Importa herramientas de detección de plataforma (kIsWeb)
import 'package:flutter/foundation.dart';

// Importa la librería oficial de Google Sign-In para autenticación federada
import 'package:google_sign_in/google_sign_in.dart';

// Importa los modelos AuthUser y UserRole
import '../../models/models.dart';

// Importa el contrato abstracto de autenticación
import 'auth_repository.dart';

// Importa el repositorio de Firestore para consultar y guardar el rol del usuario
import '../firebase/firestore_repository.dart';

/// Implementación concreta de [AuthRepository] que interactúa con los servicios reales de Firebase.
class FirebaseAuthRepository implements AuthRepository {
  /// Instancia del cliente de Firebase Authentication
  final FirebaseAuth _auth;

  /// Cliente para el flujo nativo de Google Sign-In en plataformas móviles
  final GoogleSignIn _googleSignIn;

  /// Repositorio de base de datos para almacenar y leer metadatos de usuario
  final FirestoreRepository _repository;

  /// Constructor con valores por defecto o dependencias inyectables para pruebas
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirestoreRepository? repository,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _repository = repository ?? FirestoreRepository();

  /// Retorna el usuario actualmente autenticado en Firebase Auth mapeado a [AuthUser]
  @override
  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  /// Inicia sesión con correo electrónico y contraseña en Firebase Auth
  @override
  Future<AuthUser> signIn(String email, String password) async {
    // Autentica contra los servidores de Firebase Auth
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Obtiene el AuthUser y consulta su rol personalizado guardado en Firestore
    final user = await _safeWithStoredRole(_requireUser(credential.user));

    try {
      // Sincroniza la última fecha de acceso en la base de datos
      await _repository.saveUser(user);
    } catch (_) {
      // Si la sincronización secundaria falla, no bloquea el inicio de sesión del usuario
    }
    return user;
  }

  /// Crea una nueva cuenta en Firebase Auth y registra el perfil inicial con su rol en Firestore
  @override
  Future<AuthUser> signUp(String email, String password, String name, UserRole role) async {
    // Registra las credenciales en Firebase Authentication
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Actualiza el nombre visible del usuario en su token de autenticación
    if (credential.user != null && name.isNotEmpty) {
      await credential.user!.updateDisplayName(name);
    }

    // Instancia el objeto de dominio con el rol seleccionado
    final user = AuthUser(
      id: credential.user!.uid,
      name: name.isNotEmpty ? name : (credential.user!.displayName ?? 'Usuario PROVEO'),
      email: email,
      role: role,
    );

    try {
      // Persiste el documento de usuario en la colección 'users' de Firestore
      await _repository.saveUser(user);
    } catch (_) {
      // Manejo tolerante a fallos si Firestore tiene latencia de red
    }
    return user;
  }

  /// Inicia sesión con cuenta de Google adaptándose automáticamente entre Web y Móvil
  @override
  Future<AuthUser> signInWithGoogle() async {
    UserCredential credential;

    // En entorno Web, utiliza ventana emergente (popup) optimizada para navegadores
    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});
      credential = await _auth.signInWithPopup(provider);
    } 
    // En entornos móviles nativos (Android / iOS)
    else {
      final account = await _googleSignIn.signIn();
      // Si el usuario cierra el selector de cuenta de Google
      if (account == null) {
        throw FirebaseAuthException(
          code: 'cancelled-by-user',
          message: 'Inicio de sesión cancelado.',
        );
      }
      final authentication = await account.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );
      credential = await _auth.signInWithCredential(googleCredential);
    }

    // Enriquece la identidad con el rol configurado en Firestore
    final user = await _safeWithStoredRole(_requireUser(credential.user));

    try {
      // Guarda o actualiza el usuario en la base de datos
      await _repository.saveUser(user);
    } catch (_) {
      // No interrumpe la sesión por fallos en la actualización
    }
    return user;
  }

  /// Consulta el rol guardado en Firestore para el usuario, manteniendo 'entrepreneur' como fallback
  Future<AuthUser> _safeWithStoredRole(AuthUser user) async {
    try {
      final role = await _repository.getUserRole(user.id);
      return role == null
          ? user
          : AuthUser(id: user.id, name: user.name, email: user.email, role: role);
    } catch (_) {
      return user;
    }
  }

  /// Cierra la sesión activa tanto en Google Sign-In como en Firebase Auth
  @override
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  /// Valida que el usuario retornado por Firebase no sea nulo, lanzando excepción si no existe
  AuthUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No se pudo recuperar la sesión.',
      );
    }
    return mapped;
  }

  /// Mapea un [User] nativo de Firebase a nuestro modelo tipado inmutable [AuthUser]
  AuthUser? _mapUser(User? user) => user == null
      ? null
      : AuthUser(
          id: user.uid,
          name: user.displayName ?? 'Usuario PROVEO',
          email: user.email ?? '',
          role: UserRole.entrepreneur,
        );
}