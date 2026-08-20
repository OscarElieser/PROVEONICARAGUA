import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/proveo_logo.dart';
import 'app_shell.dart';

/// Pantalla de entrada de la demo. La decision de sesion queda encapsulada
/// aqui para sustituirse luego por el estado de Firebase Auth.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..forward();
    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const AppShell()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: .94, end: 1).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ProveoLogo(height: 54),
                const SizedBox(height: 24),
                Text(
                  'Conectamos confianza. Impulsamos negocios.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
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