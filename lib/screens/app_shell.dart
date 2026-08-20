import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import 'chat_screen.dart';
import 'admin_dashboard_screen.dart';
import 'provider_dashboard_screen.dart';
import 'home_screen.dart';
import 'match_screen.dart';
import 'profile_screen.dart';
import 'quotations_screen.dart';
import 'search_screen.dart';

/// Contenedor principal con navegación en modo Hamburguesa Desplegable (Drawer)
/// para dar 100% de visibilidad panorámica a las páginas principales.
class AppShell extends StatefulWidget {
  final AuthUser user;
  final Future<void> Function() onSignOut;

  const AppShell({super.key, required this.user, required this.onSignOut});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  late final List<Widget> pages;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeScreen(),
      const SearchScreen(),
      const MatchScreen(),
      const QuotationsScreen(),
      const ChatScreen(),
      ProfileScreen(user: widget.user, onSignOut: widget.onSignOut),
      if (widget.user.role == UserRole.provider)
        const ProviderDashboardScreen(),
      if (widget.user.role == UserRole.admin) const AdminDashboardScreen()
    ];
  }

  void _onSelectDestination(int value) {
    setState(() => index = value);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop(); // Cierra el menú hamburguesa
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinations = <NavigationDestination>[
      const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Inicio'),
      const NavigationDestination(
          icon: Icon(Icons.search_rounded),
          selectedIcon: Icon(Icons.search),
          label: 'Buscar'),
      const NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined),
          selectedIcon: Icon(Icons.auto_awesome_rounded),
          label: 'Match'),
      const NavigationDestination(
          icon: Icon(Icons.request_quote_outlined),
          selectedIcon: Icon(Icons.request_quote_rounded),
          label: 'Cotizar'),
      const NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat'),
      const NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Perfil'),
    ];

    if (widget.user.role == UserRole.provider) {
      destinations.add(const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront_rounded),
          label: 'Empresa'));
    }
    if (widget.user.role == UserRole.admin) {
      destinations.add(const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings_rounded),
          label: 'Admin'));
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildHamburgerDrawer(),
      body: Stack(
        children: [
          // Página principal a pantalla completa (100% de vista disponible)
          Positioned.fill(
            child: pages[index],
          ),

          // Botón Hamburguesa Flotante Premium (siempre accesible)
          Positioned(
            top: 14,
            left: 14,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            _getCurrentPageLabel(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.trustGreen, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 768
          ? NavigationBar(
              selectedIndex: index > 5 ? 0 : index,
              onDestinationSelected: (value) => setState(() => index = value),
              destinations: destinations.take(6).toList(),
            )
          : null,
    );
  }

  String _getCurrentPageLabel() {
    switch (index) {
      case 0:
        return 'Inicio';
      case 1:
        return 'Buscar Proveedores';
      case 2:
        return 'PROVEO Match';
      case 3:
        return 'Cotizaciones';
      case 4:
        return 'Mensajes';
      case 5:
        return 'Mi Perfil';
      case 6:
        return widget.user.role == UserRole.provider ? 'Panel Empresa' : 'Administración';
      case 7:
        return 'Administración';
      default:
        return 'Menú';
    }
  }

  // ── Menú Hamburguesa Desplegable (Slide Drawer) ───────────────────────
  Widget _buildHamburgerDrawer() {
    return Drawer(
      backgroundColor: AppColors.navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del Drawer con Marca y Usuario
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blue],
                ),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.inventory_2_rounded, color: AppColors.trustGreen, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'PROVEO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.teal,
                        child: Text(
                          widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            Text(
                              widget.user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Opciones de Navegación del Menú Hamburguesa
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                children: [
                  _drawerItem(Icons.home_outlined, Icons.home_rounded, 'Inicio', 0),
                  _drawerItem(Icons.search_rounded, Icons.search, 'Buscar Proveedores', 1),
                  _drawerItem(Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'PROVEO Match con IA', 2, badge: 'IA Match'),
                  _drawerItem(Icons.request_quote_outlined, Icons.request_quote_rounded, 'Mis Cotizaciones', 3),
                  _drawerItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Mensajes y Negociación', 4),
                  _drawerItem(Icons.person_outline_rounded, Icons.person_rounded, 'Mi Perfil', 5),
                  if (widget.user.role == UserRole.provider)
                    _drawerItem(Icons.storefront_outlined, Icons.storefront_rounded, 'Panel de Empresa', 6),
                  if (widget.user.role == UserRole.admin)
                    _drawerItem(Icons.admin_panel_settings_outlined, Icons.admin_panel_settings_rounded, 'Panel de Administración', 7),
                ],
              ),
            ),

            // Footer con botón de cerrar sesión
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await widget.onSignOut();
                },
                icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.white70),
                label: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, IconData selectedIcon, String label, int value, {String? badge}) {
    final isSelected = index == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? AppColors.trustGreen : Colors.white70,
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.trustGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        selected: isSelected,
        selectedTileColor: Colors.white.withValues(alpha: 0.12),
        onTap: () => _onSelectDestination(value),
      ),
    );
  }
}
