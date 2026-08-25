// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Contacto y Atención Empresarial (lib/screens/contact_screen.dart)
// ¿Qué hace?: Despliega los canales oficiales de atención (oficinas, correos, WhatsApp) y un formulario directo de contacto.
// ¿Por qué se utiliza?: Facilita la comunicación entre prospectos, usuarios corporativos y el equipo de operaciones de Proveo.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Pantalla de atención y formulario de soporte institucional.
class ContactScreen extends StatelessWidget {
  /// Constructor constante
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Contacto'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. HERO BANNER: Encabezado con gradiente azul-verde marino
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.navy, AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.mail_outline_rounded, color: AppColors.trustGreen, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Contáctanos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Estamos aquí para ayudarte a crecer',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. SECCIÓN PRINCIPAL: Datos de Contacto y Formulario de Mensaje
          // ------------------------------------------------------------------
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Columna izquierda: Información directa de contacto
                      const Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información Directa',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navy),
                            ),
                            SizedBox(height: 24),
                            _ContactInfoTile(
                              icon: Icons.location_on_outlined,
                              title: 'Nuestras Oficinas',
                              subtitle: 'Managua, Nicaragua\nEdificio PROVEO, Piso 4',
                            ),
                            SizedBox(height: 24),
                            _ContactInfoTile(
                              icon: Icons.email_outlined,
                              title: 'Correo Electrónico',
                              subtitle: 'soporte@proveonicaragua.com\nventas@proveonicaragua.com',
                            ),
                            SizedBox(height: 24),
                            _ContactInfoTile(
                              icon: Icons.phone_outlined,
                              title: 'Teléfono',
                              subtitle: '+505 2200-0000\n+505 8800-0000 (WhatsApp)',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),

                      // Columna derecha: Tarjeta con formulario de contacto
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Envíanos un mensaje',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Campo de Nombre
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Completo',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Campo de Correo
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Campo de Mensaje multilínea
                              TextFormField(
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Mensaje',
                                  border: OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Botón de Enviar
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: FilledButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Mensaje enviado con éxito. Te contactaremos pronto.'),
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Enviar Mensaje',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 3. PIE DE PÁGINA UNIVERSAL
          // ------------------------------------------------------------------
          const SliverToBoxAdapter(child: PremiumFooter()),
        ],
      ),
    );
  }
}

/// Elemento para mostrar un canal de contacto directo con icono y subtítulo explicativo.
class _ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactInfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.paleBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.blue, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

