import '../../models/models.dart';

/// Contrato de autenticacion. Firebase Auth puede implementarlo sin cambiar
/// las pantallas ni los casos de uso.
abstract interface class AuthRepository {
  AuthUser? get currentUser;
  Future<AuthUser> signIn(String email, String password);
  Future<AuthUser> signInWithGoogle();
  Future<void> signOut();
}

/// Sesion demo para ejecutar PROVEO sin credenciales externas.
class MockAuthRepository implements AuthRepository {
  AuthUser? _currentUser = const AuthUser(
    id: 'demo-entrepreneur',
    name: 'Carlos González',
    email: 'emprendedor@demo.proveo',
    role: UserRole.entrepreneur,
  );

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signIn(String email, String password) async {
    if (email == 'proveedor@demo.proveo') {
      _currentUser = const AuthUser(id: 'demo-provider', name: 'PlastiPack Nicaragua', email: 'proveedor@demo.proveo', role: UserRole.provider);
    } else if (email == 'admin@demo.proveo') {
      _currentUser = const AuthUser(id: 'demo-admin', name: 'Admin PROVEO', email: 'admin@demo.proveo', role: UserRole.admin);
    } else if (email == 'auditor@demo.proveo') {
      _currentUser = const AuthUser(id: 'demo-auditor', name: 'Auditor PROVEO', email: 'auditor@demo.proveo', role: UserRole.auditor);
    } else {
      _currentUser = const AuthUser(id: 'demo-entrepreneur', name: 'Carlos González', email: 'emprendedor@demo.proveo', role: UserRole.entrepreneur);
    }
    return _currentUser!;
  }

  @override
  Future<AuthUser> signInWithGoogle() async => signIn('emprendedor@demo.proveo', 'demo');

  @override
  Future<void> signOut() async => _currentUser = null;
}