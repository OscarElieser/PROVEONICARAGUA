// ==============================================================================
// PROVEO NICARAGUA - Pantalla de Perfil de Usuario y Ajustes (lib/screens/profile_screen.dart)
// ¿Qué hace?: Presenta la información de cuenta, métricas de actividad (búsquedas, cotizaciones), edición de datos y logout.
// ¿Por qué se utiliza?: Permite al usuario consultar y gestionar su identidad comercial dentro de la plataforma.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa Provider para interactuar con AuthProvider y cerrar sesión
import 'package:provider/provider.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa los modelos del dominio de usuario
import '../models/models.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

// Importa el proveedor de autenticación
import '../core/providers/auth_provider.dart';

/// Pantalla de gestión de perfil empresarial y datos de cuenta.
class ProfileScreen extends StatefulWidget {
  /// Modelo del usuario cuya información se está visualizando
  final AuthUser user;

  /// Constructor con el usuario requerido
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Bandera que controla si el formulario se encuentra en modo edición o solo lectura
  bool _isEditing = false;

  /// Controladores de texto para los campos editables
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con la información actual del usuario
    _nameCtrl = TextEditingController(text: widget.user.name);
    _phoneCtrl = TextEditingController(text: '+505 8888 8888'); // Teléfono inicial de demostración
    _addressCtrl = TextEditingController(text: 'Managua, Nicaragua'); // Dirección inicial
  }

  @override
  void dispose() {
    // Libera los controladores de texto para evitar consumo innecesario de memoria
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Perfil'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. HERO BANNER: Portada degradada con avatar, nombre e insignia de rol
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blue, AppColors.teal],
                ),
              ),
              child: Stack(
                children: [
                  // Esferas decorativas transparentes
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Avatar e información centrada
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.teal,
                              child: Text(
                                _initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isEditing ? 'Editando Perfil' : widget.user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          // Badge con el rol del usuario
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.trustGreen.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _roleName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
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

          // ------------------------------------------------------------------
          // 2. CONTENIDO PRINCIPAL: Información, Estadísticas y Acciones
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botón de alternancia entre modo lectura y edición
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _isEditing ? AppColors.trustGreen : AppColors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isEditing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Perfil guardado exitosamente')),
                            );
                          }
                          _isEditing = !_isEditing;
                        });
                      },
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      label: Text(_isEditing ? 'Guardar Cambios' : 'Editar Perfil'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tarjeta con información de la cuenta
                  _SectionCard(
                    title: 'Información de Cuenta',
                    icon: Icons.manage_accounts_outlined,
                    child: Column(
                      children: [
                        if (!_isEditing) ...[
                          _InfoRow(
                            icon: Icons.business_outlined,
                            label: 'Nombre de la Empresa',
                            value: _nameCtrl.text,
                          ),
                          const Divider(height: 1),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Correo electrónico',
                            value: widget.user.email,
                          ),
                          const Divider(height: 1),
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                            value: _phoneCtrl.text,
                          ),
                          const Divider(height: 1),
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'Dirección',
                            value: _addressCtrl.text,
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre de la Empresa',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: TextEditingController(text: widget.user.email),
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    labelText: 'Correo electrónico (Solo Lectura)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _phoneCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Teléfono',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _addressCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Dirección',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!_isEditing) ...[
                    // Sección de estadísticas de actividad del usuario en la plataforma
                    _SectionCard(
                      title: 'Mi Actividad',
                      icon: Icons.bar_chart_outlined,
                      child: Row(
                        children: [
                          const Expanded(
                            child: _StatCell(
                              value: '12',
                              label: 'Búsquedas',
                              icon: Icons.search_rounded,
                              color: AppColors.blue,
                            ),
                          ),
                          Container(width: 1, height: 60, color: AppColors.border),
                          const Expanded(
                            child: _StatCell(
                              value: '8',
                              label: 'Guardados',
                              icon: Icons.bookmark_rounded,
                              color: AppColors.trustGreen,
                            ),
                          ),
                          Container(width: 1, height: 60, color: AppColors.border),
                          const Expanded(
                            child: _StatCell(
                              value: '3',
                              label: 'Cotizaciones',
                              icon: Icons.receipt_long_rounded,
                              color: AppColors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Accesos rápidos y configuración
                    _SectionCard(
                      title: 'Acciones',
                      icon: Icons.bolt_outlined,
                      child: Column(
                        children: [
                          _ActionTile(
                            icon: Icons.notifications_outlined,
                            label: 'Notificaciones',
                            subtitle: 'Configurar alertas de proveedores',
                            color: AppColors.blue,
                            onTap: () {
                              Navigator.pushNamed(context, '/notifications');
                            },
                          ),
                          const Divider(height: 1),
                          _ActionTile(
                            icon: Icons.history_rounded,
                            label: 'Historial de Cotizaciones',
                            subtitle: 'Ver todas tus cotizaciones pasadas',
                            color: AppColors.teal,
                            onTap: () {
                              Navigator.pushNamed(context, '/quotations');
                            },
                          ),
                          const Divider(height: 1),
                          _ActionTile(
                            icon: Icons.help_outline,
                            label: 'Centro de ayuda',
                            subtitle: 'Guías y soporte PROVEO',
                            color: AppColors.teal,
                            onTap: () {
                              Navigator.pushNamed(context, '/help');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de cerrar sesión con diálogo de confirmación
                    ElevatedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text(
                              '¿Cerrar sesión?',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            content: const Text('Se cerrará tu sesión activa en PROVEO.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogCtx, false),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                onPressed: () => Navigator.pop(dialogCtx, true),
                                child: const Text('Sí, cerrar sesión'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && context.mounted) {
                          await Provider.of<AuthProvider>(context, listen: false).signOut();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withValues(alpha: 0.08),
                        foregroundColor: AppColors.error,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 22),
                      label: const Text(
                        'Cerrar sesión',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Versión y créditos de la plataforma
                    const Center(
                      child: Text(
                        'PROVEO Nicaragua • v1.0.0',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
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

  /// Calcula las iniciales del usuario para mostrarlas en el avatar
  String get _initials {
    final names = widget.user.name.trim().split(RegExp(r'\s+'));
    if (names.length == 1) return names.first.substring(0, names.first.length.clamp(0, 2)).toUpperCase();
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  /// Obtiene la etiqueta en lenguaje natural correspondiente al rol del usuario
  String get _roleName {
    switch (widget.user.role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.provider:
        return 'Proveedor Verificado';
      case UserRole.auditor:
        return 'Auditor';
      default:
        return 'Emprendedor';
    }
  }
}

/// Contenedor de sección estilizado con icono, título y divisor decorativo.
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.blue),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

/// Renglón que despliega un campo de información con su etiqueta, icono y valor.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Muestra una celda estadística vertical (número destacado y descripción).
class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCell({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Elemento interactivo de acción rápida con navegación hacia subpantallas.
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

