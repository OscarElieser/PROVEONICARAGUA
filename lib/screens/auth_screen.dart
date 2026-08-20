// Importaciones necesarias para autenticación Firebase y UI de Flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/proveo_logo.dart';
import '../models/models.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../services/firebase/firebase_service.dart';
import 'app_shell.dart';

/// Pantalla de acceso ultra-premium de PROVEO con soporte Firebase y modo explorador invitado.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;
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
    _name.dispose();
    super.dispose();
  }

  Future<void> _signIn(Future<AuthUser> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      final password = _password.text;

      // Acceso de respaldo rápido si se ingresa cuenta demo
      if (email.contains('demo') || email.endsWith('@demo.proveo')) {
        final mock = MockAuthRepository();
        final user = await mock.signIn(email, password);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AppShell(user: user, onSignOut: _signOut)),
        );
        return;
      }

      final user = await action();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AppShell(user: user, onSignOut: _signOut)),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyError(e.code));
    } on FirebaseException catch (e) {
      setState(() => _error = 'Firebase: ${e.message ?? e.code}');
    } catch (e) {
      setState(() => _error = 'Error al iniciar sesión: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startGuestVisit() async {
    setState(() => _loading = true);
    // Sesión de visita guiada como emprendedor
    const guestUser = AuthUser(
      id: 'guest_session',
      name: 'Visitante Invitado',
      email: 'invitado@proveo.ni',
      role: UserRole.entrepreneur,
    );
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AppShell(user: guestUser, onSignOut: _signOut)),
    );
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos. Verifica tus datos e intenta de nuevo.';
      case 'email-already-in-use':
        return 'Este correo ya tiene una cuenta registrada. Por favor inicia sesión.';
      case 'invalid-email':
        return 'Escribe un correo electrónico válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'popup-blocked':
        return 'Tu navegador bloqueó la ventana de Google. Habilita las ventanas emergentes.';
      case 'popup-closed-by-user':
      case 'cancelled-by-user':
        return 'La autenticación con Google fue cancelada.';
      case 'network-request-failed':
        return 'Sin conexión con el servidor. Revisa tu red.';
      default:
        return 'No pudimos autenticarte en este momento. Intenta de nuevo.';
    }
  }

  Future<void> _signOut() async {
    await _authRepository.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Fondo decorativo con gradiente suave
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trustGreen.withValues(alpha: 0.06),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tarjeta Principal Ultra-Premium
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo de PROVEO
                          const Center(child: ProveoLogo(height: 52)),
                          const SizedBox(height: 20),

                          // Título y Subtítulo
                          Text(
                            _isSignUp ? 'Crear Cuenta Empresarial' : 'Bienvenido a PROVEO',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isSignUp
                                ? 'Regístrate para conectar con fabricantes y compradores verificados.'
                                : 'Conecta con proveedores confiables y toma mejores decisiones.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.35),
                          ),
                          const SizedBox(height: 24),

                          // Selector Tabs: Iniciar Sesión / Registrarse
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () => setState(() {
                                      _isSignUp = false;
                                      _error = null;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: !_isSignUp ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: !_isSignUp
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        'Iniciar Sesión',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                          color: !_isSignUp ? AppColors.navy : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () => setState(() {
                                      _isSignUp = true;
                                      _error = null;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: _isSignUp ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: _isSignUp
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.06),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        'Registrarse',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                          color: _isSignUp ? AppColors.navy : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo Nombre (si es registro)
                          if (_isSignUp) ...[
                            TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                labelText: 'Nombre de la Empresa o Representante',
                                prefixIcon: const Icon(Icons.business_outlined, color: AppColors.navy, size: 20),
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Campo Correo Electrónico
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico corporativo',
                              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.navy, size: 20),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Campo Contraseña con botón de mostrar/ocultar
                          TextField(
                            controller: _password,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.navy, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),

                          // Mensaje de Error
                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 22),

                          // Botón Principal Iniciar Sesión / Registrar
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 2,
                            ),
                            onPressed: _loading
                                ? null
                                : () {
                                    if (_isSignUp) {
                                      _signIn(() => _authRepository.signUp(
                                            _email.text.trim(),
                                            _password.text,
                                            _name.text.trim().isEmpty ? 'Nueva Empresa' : _name.text.trim(),
                                            UserRole.entrepreneur,
                                          ));
                                    } else {
                                      _signIn(() => _authRepository.signIn(_email.text.trim(), _password.text));
                                    }
                                  },
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                  )
                                : Text(
                                    _isSignUp ? 'Crear Cuenta Empresarial' : 'Iniciar Sesión',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.3),
                                  ),
                          ),
                          const SizedBox(height: 12),

                          // Botón Continuar con Google
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.border, width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _loading ? null : () => _signIn(_authRepository.signInWithGoogle),
                            icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.navy),
                            label: const Text(
                              'Continuar con Google',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Separador
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('O prueba la plataforma', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Botón de Visita Exploratoria Invitado (1 sola visita de prueba)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.trustGreen,
                              backgroundColor: AppColors.trustGreen.withValues(alpha: 0.06),
                              side: BorderSide(color: AppColors.trustGreen.withValues(alpha: 0.3), width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _loading ? null : _startGuestVisit,
                            icon: const Icon(Icons.visibility_outlined, size: 20, color: AppColors.trustGreen),
                            label: const Text(
                              'Explorar como Invitado (Visita de prueba)',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pie de Seguridad y Respaldo
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 6),
                        Text(
                          'Cifrado y seguridad protegidos por Google Cloud Firebase',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
