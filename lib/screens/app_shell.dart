import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'admin_dashboard_screen.dart';
import 'auditor_screen.dart';
import 'chat_screen.dart';
import 'entrepreneur_dashboard_screen.dart';
import 'home_screen.dart';
import 'match_screen.dart';
import 'profile_screen.dart';
import 'quotations_screen.dart';
import 'search_screen.dart';
import 'provider_dashboard_screen.dart';

/// Contenedor principal con navegacion adaptada a movil y escritorio.
class AppShell extends StatefulWidget { const AppShell({super.key}); @override State<AppShell> createState() => _AppShellState(); }
class _AppShellState extends State<AppShell> {
	int index = 0;
	String role = 'Emprendedor';
	final pages = const [HomeScreen(), SearchScreen(), MatchScreen(), QuotationsScreen(), ChatScreen(), ProfileScreen()];
	@override Widget build(BuildContext context) { final desktop = MediaQuery.sizeOf(context).width >= 960; return Scaffold(body: Row(children: [if (desktop) _sidebar(), Expanded(child: pages[index])]), bottomNavigationBar: desktop ? null : NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'), NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'), NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'Match'), NavigationDestination(icon: Icon(Icons.request_quote_outlined), label: 'Cotizar'), NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil')])); }
	Widget _sidebar() => Container(width: 248, color: AppColors.navy, child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [const Padding(padding: EdgeInsets.all(24), child: Text('PROVEO', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 2))), _item(Icons.home_outlined, 'Inicio', 0), _item(Icons.search, 'Buscar proveedores', 1), _item(Icons.auto_awesome_outlined, 'PROVEO Match', 2), _item(Icons.request_quote_outlined, 'Cotizaciones', 3), _item(Icons.chat_bubble_outline, 'Mensajes', 4), _item(Icons.person_outline, 'Mi perfil', 5), const Spacer(), Padding(padding: const EdgeInsets.all(16), child: DropdownButtonFormField<String>(initialValue: role, dropdownColor: AppColors.darkBlue, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Rol demo', labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38))), items: const ['Emprendedor', 'Proveedor', 'Administrador', 'Auditor'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) { if (value == null) return; setState(() => role = value); Navigator.push(context, MaterialPageRoute(builder: (_) => _dashboardFor(value))); })), const Padding(padding: EdgeInsets.all(20), child: Text('Demo Hackathon  •  v1.0', style: TextStyle(color: Colors.white54, fontSize: 11)))])));
	Widget _dashboardFor(String value) { switch (value) { case 'Proveedor': return const ProviderDashboardScreen(); case 'Administrador': return const AdminDashboardScreen(); case 'Auditor': return const AuditorScreen(); default: return const EntrepreneurDashboardScreen(); } }
	Widget _item(IconData icon, String label, int value) => ListTile(leading: Icon(icon, color: index == value ? AppColors.successGreen : Colors.white70), title: Text(label, style: TextStyle(color: index == value ? Colors.white : Colors.white70)), selected: index == value, selectedTileColor: Colors.white.withValues(alpha: .1), onTap: () => setState(() => index = value));
}
