import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/models.dart';
import 'auth_repository.dart';
import '../firebase/firestore_repository.dart';

/// Implementacion real de autenticacion para Firebase Auth.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirestoreRepository _repository;

  FirebaseAuthRepository({FirebaseAuth? auth, GoogleSignIn? googleSignIn, FirestoreRepository? repository})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _repository = repository ?? FirestoreRepository();

  @override
  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AuthUser> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = await _withStoredRole(_requireUser(credential.user));
    await _repository.saveUser(user);
    return user;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    UserCredential credential;
    if (kIsWeb) {
      credential = await _auth.signInWithPopup(GoogleAuthProvider());
    } else {
      final account = await _googleSignIn.signIn();
      if (account == null) throw FirebaseAuthException(code: 'cancelled-by-user', message: 'Inicio de sesión cancelado.');
      final authentication = await account.authentication;
      final googleCredential = GoogleAuthProvider.credential(idToken: authentication.idToken);
      credential = await _auth.signInWithCredential(googleCredential);
    }
    final user = await _withStoredRole(_requireUser(credential.user));
    await _repository.saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    if (!kIsWeb) await _googleSignIn.signOut();
    await _auth.signOut();
  }

  AuthUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) throw FirebaseAuthException(code: 'user-not-found', message: 'No se pudo recuperar la sesión.');
    return mapped;
  }

  Future<AuthUser> _withStoredRole(AuthUser user) async {
    final role = await _repository.getUserRole(user.id);
    return role == null ? user : AuthUser(id: user.id, name: user.name, email: user.email, role: role);
  }

  AuthUser? _mapUser(User? user) => user == null ? null : AuthUser(id: user.uid, name: user.displayName ?? 'Usuario PROVEO', email: user.email ?? '', role: UserRole.entrepreneur);
}