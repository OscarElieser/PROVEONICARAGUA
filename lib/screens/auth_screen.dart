import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/proveo_logo.dart';
import '../models/models.dart';
import '../services/auth/firebase_auth_repository.dart';
import 'app_shell.dart';

/// Acceso real a PROVEO mediante Firebase Authentication.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  FirebaseAuthRepository? _repository;
  bool _loading = false;
  String? _error;

  FirebaseAuthRepository get _authRepository => _repository ??= FirebaseAuthRepository();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn(Future<AuthUser> Function() action) async {
    setState(() { _loading = true; _error = null; });
    try {
      final user = await action();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AppShell(user: user)));
    } on FirebaseAuthException catch (error) {
      setState(() => _error = _friendlyError(error.code));
    } catch (_) {
      setState(() => _error = 'No pudimos iniciar sesión. Intenta nuevamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'El correo o la contraseña no son correctos.';
      case 'invalid-email':
        return 'Escribe un correo electrónico válido.';
      default:
        return 'No pudimos iniciar sesión. Revisa tu conexión e inténtalo de nuevo.';
    }
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
              const Text('Conecta con proveedores confiables y toma mejores decisiones.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo electrónico', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 14),
              TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline))),
              if (_error != null) ...[const SizedBox(height: 14), Text(_error!, style: const TextStyle(color: AppColors.error))],
              const SizedBox(height: 22),
              FilledButton(onPressed: _loading ? null : () => _signIn(() => _authRepository.signIn(_email.text.trim(), _password.text)), child: _loading ? const CircularProgressIndicator() : const Text('Iniciar sesión')),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: _loading ? null : () => _signIn(_authRepository.signInWithGoogle), icon: const Icon(Icons.account_circle_outlined), label: const Text('Continuar con Google')),
              const SizedBox(height: 22),
              const Text('Tu cuenta y tus datos se protegen con Firebase Authentication.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ),
        ),
      ),
    );
  }
}