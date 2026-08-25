// ==============================================================================
// PROVEO NICARAGUA - Contrato e Implementación Mock de Autenticación (lib/services/auth/auth_repository.dart)
// ¿Qué hace?: Declara la interfaz abstracta AuthRepository y provee una implementación en memoria (MockAuthRepository).
// ¿Por qué se utiliza?: Permite el desacoplamiento total de la UI respecto a Firebase Auth y habilita pruebas sin conexión.
// ==============================================================================

// Importa las entidades del dominio de usuario
import '../../models/models.dart';

/// Interfaz abstracta que define las operaciones obligatorias para cualquier mecanismo de autenticación en PROVEO.
///
/// La UI y los Providers dependen de este contrato, permitiendo alternar entre Firebase real y Mocks de pruebas.
abstract interface class AuthRepository {
  /// Retorna el usuario con sesión activa en el repositorio, o null si no hay sesión iniciada.
  AuthUser? get currentUser;

  /// Inicia sesión validando credenciales de correo electrónico y contraseña.
  Future<AuthUser> signIn(String email, String password);

  /// Registra una nueva cuenta de usuario con sus datos de perfil y rol inicial.
  Future<AuthUser> signUp(String email, String password, String name, UserRole role);

  /// Inicia sesión mediante el flujo OAuth2 de Google Sign-In.
  Future<AuthUser> signInWithGoogle();

  /// Cierra la sesión activa actual y limpia credenciales almacenadas.
  Future<void> signOut();
}

/// Implementación simulada (Mock) en memoria para entornos locales o pruebas sin conexión a Firebase.
class MockAuthRepository implements AuthRepository {
  /// Almacena el usuario autenticado en la memoria volátil de la sesión.
  AuthUser? _currentUser = const AuthUser(
    id: 'demo-entrepreneur',
    name: 'Carlos González',
    email: 'emprendedor@demo.proveo',
    role: UserRole.entrepreneur,
  );

  @override
  AuthUser? get currentUser => _currentUser;

  /// Simula el inicio de sesión asignando roles según el correo de prueba ingresado.
  @override
  Future<AuthUser> signIn(String email, String password) async {
    // Si se prueba el rol de Proveedor
    if (email == 'proveedor@demo.proveo') {
      _currentUser = const AuthUser(
        id: 'demo-provider',
        name: 'PlastiPack Nicaragua',
        email: 'proveedor@demo.proveo',
        role: UserRole.provider,
      );
    } 
    // Si se prueba el rol de Administrador
    else if (email == 'admin@demo.proveo') {
      _currentUser = const AuthUser(
        id: 'demo-admin',
        name: 'Admin PROVEO',
        email: 'admin@demo.proveo',
        role: UserRole.admin,
      );
    } 
    // Si se prueba el rol de Auditor
    else if (email == 'auditor@demo.proveo') {
      _currentUser = const AuthUser(
        id: 'demo-auditor',
        name: 'Auditor PROVEO',
        email: 'auditor@demo.proveo',
        role: UserRole.auditor,
      );
    } 
    // Por defecto inicia como Emprendedor
    else {
      _currentUser = const AuthUser(
        id: 'demo-entrepreneur',
        name: 'Carlos González',
        email: 'emprendedor@demo.proveo',
        role: UserRole.entrepreneur,
      );
    }
    return _currentUser!;
  }

  /// Simula el registro generando un ID temporal basado en timestamp.
  @override
  Future<AuthUser> signUp(String email, String password, String name, UserRole role) async {
    _currentUser = AuthUser(
      id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
    );
    return _currentUser!;
  }

  /// Simula el acceso con Google redirigiendo a la cuenta demo de emprendedor.
  @override
  Future<AuthUser> signInWithGoogle() async => signIn('emprendedor@demo.proveo', 'demo');

  /// Simula el cierre de sesión purgando la referencia en memoria.
  @override
  Future<void> signOut() async => _currentUser = null;
}