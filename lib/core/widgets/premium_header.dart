import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../screens/search_screen.dart';
import '../../screens/match_screen.dart';
import '../../screens/quotations_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/about_us_screen.dart';
import '../../screens/quotation_request_screen.dart';
import '../../screens/admin_dashboard_screen.dart';
import '../../screens/auth_screen.dart';
import '../../screens/notifications_screen.dart';
import '../../screens/profile_screen.dart';

/// Barra de Navegación Principal Universal para todas las pantallas de PROVEO.
/// Proporciona acceso consistente al menú principal, logo interactivo y buscador.
class PremiumHeader extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final bool showBackButton;

  const PremiumHeader({
    super.key,
    this.currentPage = '',
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final canPop = showBackButton && Navigator.canPop(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 950;
    final isTablet = width >= 650 && width < 950;

    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 14),
          child: Row(
            children: [
              // ── Botón Volver (si aplica) ──
              if (canPop) ...[
                IconButton(
                  tooltip: 'Volver atrás',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.paleBlue,
                    foregroundColor: AppColors.navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
              ],

              // ── Logo PROVEO Interactivo ──
              InkWell(
                onTap: () => _goHome(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.navy.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.hub_outlined,
                          color: AppColors.trustGreen,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'PROVEO',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ── Menú Principal Desktop ──
              if (isDesktop) ...[
                _NavButton(
                  label: 'Inicio',
                  icon: Icons.home_outlined,
                  isActive: currentPage == 'Inicio',
                  onTap: () => _goHome(context),
                ),
                _NavButton(
                  label: 'Proveedores',
                  icon: Icons.storefront_outlined,
                  isActive: currentPage == 'Proveedores' || currentPage == 'Buscar',
                  onTap: () => _navigateTo(context, const SearchScreen()),
                ),
                _NavButton(
                  label: 'Match IA',
                  icon: Icons.auto_awesome_rounded,
                  isActive: currentPage == 'Match' || currentPage == 'Match IA',
                  iconColor: AppColors.trustGreen,
                  onTap: () => _navigateTo(context, const MatchScreen()),
                ),
                _NavButton(
                  label: 'Cotizaciones',
                  icon: Icons.request_quote_outlined,
                  isActive: currentPage == 'Cotizaciones',
                  onTap: () => _navigateTo(context, const QuotationsScreen()),
                ),
                _NavButton(
                  label: 'Chat B2B',
                  icon: Icons.chat_bubble_outline_rounded,
                  isActive: currentPage == 'Chat' || currentPage == 'Chat B2B',
                  onTap: () => _navigateTo(context, const ChatScreen()),
                ),
                _NavButton(
                  label: 'Nosotros',
                  icon: Icons.info_outline_rounded,
                  isActive: currentPage == 'Nosotros' || currentPage == 'Acerca de',
                  onTap: () => _navigateTo(context, const AboutUsScreen()),
                ),
                const SizedBox(width: 14),
                // Botón Acción Rápida
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.trustGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => _navigateTo(context, const QuotationRequestScreen()),
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text(
                    'Cotizar',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 16),
                Container(width: 1, height: 30, color: AppColors.border),
                const SizedBox(width: 16),
                
                // Zona de Usuario / Autenticación
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final isLoggedIn = auth.isAuthenticated && auth.currentUser?.id != 'guest_session';
                    
                    if (isLoggedIn) {
                      final user = auth.currentUser!;
                      return Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.navy),
                            onPressed: () => _navigateTo(context, const NotificationsScreen()), // requires NotificationsScreen
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<int>(
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.navy,
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: const Row(
                                  children: [
                                    Icon(Icons.person_outline, color: AppColors.navy, size: 20),
                                    SizedBox(width: 12),
                                    Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: const Row(
                                  children: [
                                    Icon(Icons.history_rounded, color: AppColors.teal, size: 20),
                                    SizedBox(width: 12),
                                    Text('Historial de Cotizaciones', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                value: 3,
                                child: const Row(
                                  children: [
                                    Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                                    SizedBox(width: 12),
                                    Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 1) {
                                _navigateTo(context, ProfileScreen(user: user));
                              } else if (value == 2) {
                                _navigateTo(context, const QuotationsScreen());
                              } else if (value == 3) {
                                await auth.signOut();
                              }
                            },
                          ),
                        ],
                      );
                    } else {
                      return FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.paleBlue,
                          foregroundColor: AppColors.navy,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                          (route) => false,
                        ),
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text('Ingresar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      );
                    }
                  },
                ),
              ],

              // ── Menú Tablet / Mobile (Desplegable y Accesible) ──
              if (!isDesktop) ...[
                if (isTablet)
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.paleGreen,
                      foregroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _navigateTo(context, const QuotationRequestScreen()),
                    icon: const Icon(Icons.request_quote_rounded, size: 16, color: AppColors.trustGreen),
                    label: const Text('Cotizar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                const SizedBox(width: 8),
                PopupMenuButton<int>(
                  tooltip: 'Menú principal',
                  offset: const Offset(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_rounded, color: Colors.white, size: 20),
                  ),
                  itemBuilder: (context) => [
                    _buildPopupHeader(),
                    const PopupMenuDivider(),
                    _buildPopupItem(1, Icons.home_rounded, 'Inicio', AppColors.navy),
                    _buildPopupItem(2, Icons.storefront_rounded, 'Buscar Proveedores', AppColors.navy),
                    _buildPopupItem(3, Icons.auto_awesome_rounded, 'PROVEO Match IA', AppColors.trustGreen),
                    _buildPopupItem(4, Icons.request_quote_rounded, 'Mis Cotizaciones', AppColors.navy),
                    _buildPopupItem(5, Icons.chat_bubble_rounded, 'Mensajes y Chat B2B', AppColors.blue),
                    _buildPopupItem(6, Icons.info_rounded, 'Acerca de Nosotros', AppColors.teal),
                    const PopupMenuDivider(),
                    _buildPopupItem(7, Icons.admin_panel_settings_rounded, 'Panel de Administración', AppColors.navy),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        _goHome(context);
                        break;
                      case 2:
                        _navigateTo(context, const SearchScreen());
                        break;
                      case 3:
                        _navigateTo(context, const MatchScreen());
                        break;
                      case 4:
                        _navigateTo(context, const QuotationsScreen());
                        break;
                      case 5:
                        _navigateTo(context, const ChatScreen());
                        break;
                      case 6:
                        _navigateTo(context, const AboutUsScreen());
                        break;
                      case 7:
                        _navigateTo(context, const AdminDashboardScreen());
                        break;
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<int> _buildPopupHeader() {
    return const PopupMenuItem<int>(
      enabled: false,
      child: Row(
        children: [
          Icon(Icons.hub_rounded, color: AppColors.trustGreen, size: 20),
          SizedBox(width: 8),
          Text(
            'Menú de Navegación',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<int> _buildPopupItem(
    int value,
    IconData icon,
    String title,
    Color iconColor,
  ) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color? iconColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isActive,
    this.iconColor,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    final color = active
        ? AppColors.navy
        : (_isHovered ? AppColors.blue : AppColors.textSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: active
                ? AppColors.paleBlue
                : (_isHovered ? AppColors.background : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: widget.iconColor ?? color,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
