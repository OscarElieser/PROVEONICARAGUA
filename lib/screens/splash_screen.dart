// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Bienvenida Animada / Splash (lib/screens/splash_screen.dart)
// ¿Qué hace?: Despliega la animación de entrada del logotipo de Proveo y gestiona la transición a la pantalla de Auth.
// ¿Por qué se utiliza?: Otorga una primera impresión de alta gama (branding) mientras se precargan recursos y fuentes en memoria.
// ==============================================================================

// Importa los componentes visuales y animaciones de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el widget oficial del logotipo
import '../core/widgets/proveo_logo.dart';

// Importa la pantalla de autenticación para la redirección
import 'auth_screen.dart';

/// Pantalla de bienvenida con animación fluida de escala y fundido (fade-in).
class SplashScreen extends StatefulWidget {
  /// Constructor constante
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controlador de tiempo para orquestar la animación de entrada
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador con una duración de 1700 milisegundos para una entrada suave
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..forward(); // Inicia la reproducción hacia adelante

    // Programa la navegación hacia la pantalla de autenticación tras 1.9 segundos
    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      // Valida que el widget continúe montado en el árbol para evitar fugas o excepciones
      if (!mounted) return;

      // Reemplaza la ruta actual para que el usuario no pueda regresar al splash con el botón atrás
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Libera los recursos del AnimationController para evitar fugas de memoria (memory leaks)
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo azul marino corporativo de Proveo
      backgroundColor: AppColors.navy,
      body: Center(
        // Transición de opacidad progresiva (FadeTransition)
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
          // Transición de escala suave (de 94% a 100% de tamaño)
          child: ScaleTransition(
            scale: Tween<double>(begin: .94, end: 1).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logotipo oficial de Proveo ampliado y resaltado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.trustGreen.withValues(alpha: 0.35),
                        blurRadius: 32,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const ProveoLogo(
                    variant: ProveoLogoVariant.full,
                    height: 85,
                  ),
                ),
                const SizedBox(height: 28),
                // Lema comercial de la marca
                Text(
                  'Conectamos confianza. Impulsamos negocios.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Indicador de carga circular en verde confianza
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}