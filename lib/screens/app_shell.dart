// ==============================================================================
// PROVEO NICARAGUA - Cascarón Principal de Navegación (lib/screens/app_shell.dart)
// ¿Qué hace?: Actúa como contenedor raíz de las vistas principales con soporte de BottomNavigationBar en móviles y Drawer lateral responsivo.
// ¿Por qué se utiliza?: Centraliza la navegación basada en el rol del usuario autenticado (Emprendedor, Proveedor, Administrador).
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa Provider para acceder al estado global de autenticación
import 'package:provider/provider.dart';

// Importa la paleta de colores del tema
import '../core/theme/app_colors.dart';

// Importa el proveedor de autenticación
import '../core/providers/auth_provider.dart';

// Importa los modelos del dominio de usuario
import '../models/models.dart';

// Importa las pantallas que integran el flujo principal
import 'chat_screen.dart';
import 'admin_dashboard_screen.dart';
import 'provider_dashboard_screen.dart';
import 'home_screen.dart';
import 'match_screen.dart';
import 'profile_screen.dart';
import 'quotations_screen.dart';
import 'search_screen.dart';
import 'about_us_screen.dart';

/// Contenedor principal de la aplicación que administra las vistas activas mediante un índice seleccionado.
class AppShell extends StatefulWidget {
  /// Usuario autenticado con su rol correspondiente
  final AuthUser user;

  /// Constructor con el usuario requerido
  const AppShell({super.key, required this.user});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// Índice de la página actualmente visualizada en pantalla
  int index = 0;

  /// Lista de widgets correspondientes a cada sección del menú
  late final List<Widget> pages;

  /// Clave global para controlar el Drawer programáticamente
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Inicializa las pantallas principales e inyecta vistas condicionales según el rol del usuario
    pages = [
      const HomeScreen(),               // Índice 0: Pantalla de inicio y categorías destacadas
      const SearchScreen(),             // Índice 1: Directorio y buscador de proveedores
      const MatchScreen(),              // Índice 2: Motor de recomendación inteligente PROVEO Match
      const QuotationsScreen(),         // Índice 3: Gestión de solicitudes y presupuestos de cotización
      const ChatScreen(),               // Índice 4: Mensajería directa B2B entre empresas
      ProfileScreen(user: widget.user), // Índice 5: Perfil y configuración de cuenta
      // Si el usuario es proveedor, añade su panel operativo
      if (widget.user.role == UserRole.provider)
        const ProviderDashboardScreen(),
      // Si el usuario es administrador, añade el panel de métricas y auditoría
      if (widget.user.role == UserRole.admin) 
        const AdminDashboardScreen(),
    ];
  }

  /// Cambia de pestaña activa y cierra el Drawer si estaba abierto
  void _onSelectDestination(int value) {
    setState(() => index = value);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop(); // Cierra el menú hamburguesa
    }
  }

  @override
  Widget build(BuildContext context) {
    // Configura los destinos de navegación estándar
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Inicio',
      ),
      const NavigationDestination(
        icon: Icon(Icons.search_rounded),
        selectedIcon: Icon(Icons.search),
        label: 'Buscar',
      ),
      const NavigationDestination(
        icon: Icon(Icons.auto_awesome_outlined),
        selectedIcon: Icon(Icons.auto_awesome_rounded),
        label: 'Match',
      ),
      const NavigationDestination(
        icon: Icon(Icons.request_quote_outlined),
        selectedIcon: Icon(Icons.request_quote_rounded),
        label: 'Cotizar',
      ),
      const NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline_rounded),
        selectedIcon: Icon(Icons.chat_bubble_rounded),
        label: 'Chat',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Perfil',
      ),
    ];

    // Agrega pestaña especial si el usuario es proveedor
    if (widget.user.role == UserRole.provider) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront_rounded),
          label: 'Empresa',
        ),
      );
    }

    // Agrega pestaña especial si el usuario es administrador
    if (widget.user.role == UserRole.admin) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings_rounded),
          label: 'Admin',
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildHamburgerDrawer(), // Menú lateral deslizable
      body: pages[index],               // Renderiza la pantalla seleccionada actualmente
      // En dispositivos móviles (< 768px), muestra barra de navegación inferior
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 768
          ? NavigationBar(
              selectedIndex: index > 5 ? 0 : index,
              onDestinationSelected: (value) => setState(() => index = value),
              destinations: destinations.take(6).toList(),
            )
          : null,
    );
  }

  // --------------------------------------------------------------------------
  // MENÚ HAMBURGUESA DESPLEGABLE (Slide Drawer)
  // --------------------------------------------------------------------------
  Widget _buildHamburgerDrawer() {
    return Drawer(
      backgroundColor: AppColors.navy, // Fondo azul oscuro corporativo
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera del menú lateral con identidad de marca y datos del usuario
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blue],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
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
                  // Avatar y datos del usuario
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.teal,
                        child: Text(
                          widget.user.name.isNotEmpty
                              ? widget.user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de enlaces de navegación dentro del Drawer
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
                  const Divider(color: Colors.white24, height: 32),
                  _drawerItem(Icons.info_outline_rounded, Icons.info_rounded, 'Acerca de PROVEO', 99),
                ],
              ),
            ),

            // Pie del menú lateral con botón de cerrar sesión
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
                  await Provider.of<AuthProvider>(context, listen: false).signOut();
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

  /// Construye un elemento de lista estilizado para el Drawer con icono, texto y badge opcional
  Widget _drawerItem(
    IconData icon,
    IconData selectedIcon,
    String label,
    int value, {
    String? badge,
  }) {
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        selected: isSelected,
        selectedTileColor: Colors.white.withValues(alpha: 0.12),
        onTap: () {
          if (value == 99) {
            Navigator.of(context).pop(); // Cierra el drawer
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
          } else {
            _onSelectDestination(value);
          }
        },
      ),
    );
  }
}

