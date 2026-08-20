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

/// Contenedor principal con navegacion adaptada a movil y escritorio.
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

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 960;
    final destinations = <NavigationDestination>[
      const NavigationDestination(
          icon: Icon(Icons.home_outlined), label: 'Inicio'),
      const NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
      const NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined), label: 'Match'),
      const NavigationDestination(
          icon: Icon(Icons.request_quote_outlined), label: 'Cotizar'),
      const NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
      const NavigationDestination(
          icon: Icon(Icons.person_outline), label: 'Perfil')
    ];
    if (widget.user.role == UserRole.provider)
      destinations.add(const NavigationDestination(
          icon: Icon(Icons.storefront_outlined), label: 'Empresa'));
    if (widget.user.role == UserRole.admin)
      destinations.add(const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'));
    return Scaffold(
        body: Row(
            children: [if (desktop) _sidebar(), Expanded(child: pages[index])]),
        bottomNavigationBar: desktop
            ? null
            : NavigationBar(
                selectedIndex: index > 5 ? 0 : index,
                onDestinationSelected: (value) => setState(() => index = value),
                destinations: destinations));
  }

  Widget _sidebar() => Container(
      width: 248,
      color: AppColors.navy,
      child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Padding(
            padding: EdgeInsets.all(24),
            child: Text('PROVEO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2))),
        _item(Icons.home_outlined, 'Inicio', 0),
        _item(Icons.search, 'Buscar proveedores', 1),
        _item(Icons.auto_awesome_outlined, 'PROVEO Match', 2),
        _item(Icons.request_quote_outlined, 'Cotizaciones', 3),
        _item(Icons.chat_bubble_outline, 'Mensajes', 4),
        _item(Icons.person_outline, 'Mi perfil', 5),
        if (widget.user.role == UserRole.provider)
          _item(Icons.storefront_outlined, 'Panel proveedor', 6),
        if (widget.user.role == UserRole.admin)
          _item(Icons.admin_panel_settings_outlined, 'Administración', 7),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Text(widget.user.email,
                style: const TextStyle(color: Colors.white54, fontSize: 11)))
      ])));
  Widget _item(IconData icon, String label, int value) => ListTile(
      leading: Icon(icon,
          color: index == value ? AppColors.successGreen : Colors.white70),
      title: Text(label,
          style:
              TextStyle(color: index == value ? Colors.white : Colors.white70)),
      selected: index == value,
      selectedTileColor: Colors.white.withValues(alpha: .1),
      onTap: () => setState(() => index = value));
}
