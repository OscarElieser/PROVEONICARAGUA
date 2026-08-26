// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Autenticación y Registro B2B (lib/screens/auth_screen.dart)
// ¿Qué hace?: Gestiona el inicio de sesión con correo/contraseña, Google OAuth, registro empresarial y modo explorador invitado.
// ¿Por qué se utiliza?: Es la puerta de entrada segura para la autenticación de empresas y emprendedores en la plataforma.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa Provider para interactuar con AuthProvider
import 'package:provider/provider.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el widget oficial del logotipo
import '../core/widgets/proveo_logo.dart';

// Importa las enumeraciones de roles de usuario
import '../models/models.dart';

// Importa el gestor de estado de sesión
import '../core/providers/auth_provider.dart';

/// Pantalla de acceso de PROVEO con soporte Firebase y modo explorador invitado.
class AuthScreen extends StatefulWidget {
  /// Constructor constante
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// Controlador del campo de texto de correo electrónico
  final _email = TextEditingController();

  /// Controlador del campo de texto de contraseña
  final _password = TextEditingController();

  /// Controlador del campo de texto del nombre comercial o representante
  final _name = TextEditingController();

  /// Alterna entre el formulario de inicio de sesión (`false`) y el de registro (`true`)
  bool _isSignUp = false;

  /// Controla la visibilidad de los caracteres en el campo de contraseña
  bool _obscurePassword = true;

  /// Indicador visual de operación asíncrona en curso
  bool _loading = false;

  /// Mensaje de error a presentar en la interfaz ante fallos de validación o credenciales
  String? _error;

  @override
  void dispose() {
    // Libera los controladores de texto al desmontar el widget para evitar fugas de memoria
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  /// Ejecuta la autenticación con correo y contraseña (o registro según [_isSignUp])
  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (_isSignUp) {
        // Registro de nueva cuenta empresarial por defecto con rol Emprendedor
        await auth.signUp(
          _email.text.trim(),
          _password.text,
          _name.text.trim().isEmpty ? 'Nueva Empresa' : _name.text.trim(),
          UserRole.entrepreneur,
        );
      } else {
        // Inicio de sesión con credenciales existentes
        await auth.signIn(_email.text.trim(), _password.text);
      }

      // Si el proveedor registró un mensaje de error legible, lo mostramos
      if (mounted && auth.errorMessage != null) {
        setState(() => _error = auth.errorMessage);
      }
    } catch (e) {
      setState(() => _error = 'Error al iniciar sesión: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Ejecuta el flujo federado de autenticación con Google SignIn
  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signInWithGoogle();

      if (mounted && auth.errorMessage != null) {
        setState(() => _error = auth.errorMessage);
      }
    } catch (e) {
      setState(() => _error = 'Error con Google: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Inicia una visita exploratoria en modo invitado sin necesidad de registrar credenciales
  Future<void> _startGuestVisit() async {
    setState(() => _loading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).startGuestVisit();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ------------------------------------------------------------------
          // 1. FONDO DECORATIVO CON ESFERAS SUAVES
          // ------------------------------------------------------------------
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

          // ------------------------------------------------------------------
          // 2. FORMULARIO PRINCIPAL CENTRADO
          // ------------------------------------------------------------------
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tarjeta Principal de Autenticación
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
                          // Logotipo oficial de PROVEO ampliado
                          const Center(
                            child: ProveoLogo(
                              variant: ProveoLogoVariant.extended,
                              height: 75,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Título dinámico según modo Login / Sign Up
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
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Selector Segmentado de Pestañas: Iniciar Sesión / Registrarse
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                // Opción: Iniciar Sesión
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
                                // Opción: Registrarse
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

                          // Campo Nombre (exclusivo para registro)
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

                          // Campo Contraseña con botón interactivo de visibilidad
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

                          // Banner visual de error en caso de fallo
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
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                            onPressed: _loading ? null : _signIn,
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                  )
                                : Text(
                                    _isSignUp ? 'Crear Cuenta Empresarial' : 'Iniciar Sesión',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      letterSpacing: 0.3,
                                    ),
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
                            onPressed: _loading ? null : _signInWithGoogle,
                            icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.navy),
                            label: const Text(
                              'Continuar con Google',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Separador visual "O prueba la plataforma"
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'O prueba la plataforma',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Botón de Visita Exploratoria Invitado (acceso de prueba instantáneo)
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

                    // Pie informativo sobre seguridad y respaldo Google Cloud
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

