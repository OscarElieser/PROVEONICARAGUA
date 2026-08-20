// Importaciones necesarias para autenticacion Firebase y UI de Flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/proveo_logo.dart';
import '../models/models.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../services/firebase/firebase_service.dart';
import 'app_shell.dart';

/// Pantalla de acceso a PROVEO con soporte Firebase y modo demo sin credenciales.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  AuthRepository? _repository;
  bool _loading = false;
  String? _error;

  AuthRepository get _authRepository =>
      _repository ??= FirebaseService.isInitialized
          ? FirebaseAuthRepository()
          : MockAuthRepository();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn(Future<AuthUser> Function() action) async {
    setState(() { _loading = true; _error = null; });
    try {
      final email = _email.text.trim();
      final password = _password.text;
      
      // Si el correo es de prueba (@demo.proveo o demo), se autentica con Mock sin depender de la nube
      if (email.contains('demo') || email.endsWith('@demo.proveo')) {
        final mock = MockAuthRepository();
        final user = await mock.signIn(email, password);
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => AppShell(user: user, onSignOut: _signOut)));
        return;
      }

      final user = await action();
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => AppShell(user: user, onSignOut: _signOut)));
    } on FirebaseAuthException catch (e) {
      setState(() => _error = '${_friendlyError(e.code)} [${e.code}]');
    } on FirebaseException catch (e) {
      setState(() => _error = 'Firebase (${e.code}): ${e.message ?? e.code}');
    } catch (e) {
      setState(() => _error = 'Error al iniciar sesión: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'El correo o la contraseña no son correctos o el usuario no existe en Firebase.';
      case 'invalid-email': return 'Escribe un correo electrónico válido.';
      case 'popup-blocked': return 'Tu navegador bloqueó la ventana emergente de Google. Habilita los popups o usa "Entrar como demo".';
      case 'popup-closed-by-user':
      case 'cancelled-by-user':
        return 'La ventana de Google se cerró sin seleccionar cuenta. Usa el botón verde "Entrar como demo" para entrar directo.';
      case 'network-request-failed': return 'Sin conexión con Firebase. Revisa tu red.';
      default: return 'No pudimos iniciar sesión.';
    }
  }

  Future<void> _signOut() async {
    await _authRepository.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const ProveoLogo(height: 58),
              const SizedBox(height: 34),
              Text('Bienvenido a PROVEO', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              const Text('Conecta con proveedores confiables y toma mejores decisiones.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              TextField(controller: _email, keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo electronico', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 14),
              TextField(controller: _password, obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contrasena', prefixIcon: Icon(Icons.lock_outline))),
              if (_error != null) ...[const SizedBox(height: 14),
                Text(_error!, style: const TextStyle(color: AppColors.error))],
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _loading ? null : () => _signIn(() => _authRepository.signIn(_email.text.trim(), _password.text)),
                child: _loading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                    : const Text('Iniciar sesion'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                  onPressed: _loading ? null : () => _signIn(_authRepository.signInWithGoogle),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continuar con Google')),
              const SizedBox(height: 16),
              const Row(children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('o', style: TextStyle(color: AppColors.textSecondary))),
                Expanded(child: Divider()),
              ]),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.trustGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: _loading ? null : () {
                  final mock = MockAuthRepository();
                  _signIn(() => mock.signIn('demo', 'demo'));
                },
                icon: const Icon(Icons.rocket_launch_outlined),
                label: const Text('Entrar como demo',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.paleBlue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Icon(Icons.info_outline, size: 15, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text('Accesos demo por rol',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 8),
                  _demoRow(Icons.account_circle, 'Admin Inatec', 'oscarelieser.informatica.inatec@gmail.com'),
                  _demoRow(Icons.business_outlined, 'Pinolillo Hackathon', 'pinolillohackathon@gmail.com'),
                  const Divider(height: 14),
                  _demoRow(Icons.person_outline, 'Emprendedor Demo', 'emprendedor@demo.proveo'),
                  _demoRow(Icons.storefront_outlined, 'Proveedor Demo', 'proveedor@demo.proveo'),
                  _demoRow(Icons.admin_panel_settings_outlined, 'Admin Demo', 'admin@demo.proveo'),
                ]),
              ),
              const SizedBox(height: 22),
              const Text('Tu cuenta y tus datos se protegen con Firebase Authentication.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _demoRow(IconData icon, String role, String email) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(children: [
        Icon(icon, size: 14, color: AppColors.navy),
        const SizedBox(width: 6),
        Text('$role: ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        Expanded(child: Text(email, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
        GestureDetector(
          onTap: () {
            _email.text = email;
            _password.text = 'demo123';
            setState(() {});
          },
          child: const Text('Usar',
              style: TextStyle(fontSize: 11, color: AppColors.blue, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}
