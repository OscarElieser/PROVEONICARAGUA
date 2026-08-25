// ==============================================================================
// PROVEO NICARAGUA - Punto de Entrada Principal (lib/main.dart)
// ¿Qué hace?: Inicializa los servicios asíncronos de Firebase, configura el árbol de proveedores de estado y renderiza la interfaz raíz.
// ¿Por qué se utiliza?: Es el punto de arranque obligatorio de la aplicación Flutter en Web y móvil.
// ==============================================================================

// Importa los componentes y widgets fundamentales del SDK de Flutter Material
import 'package:flutter/material.dart';

// Importa el paquete Provider para inyección de dependencias y gestión de estado reactivo
import 'package:provider/provider.dart';

// Importa el tema visual unificado de la aplicación (paleta de colores, tipografías, estilos)
import 'core/theme/app_theme.dart';

// Importa el servicio centralizado que gestiona la inicialización de Firebase y App Check
import 'services/firebase/firebase_service.dart';

// Importa la pantalla de inicio de sesión y registro para usuarios no autenticados
import 'screens/auth_screen.dart';

// Importa el proveedor del estado de autenticación y sesión de usuario
import 'core/providers/auth_provider.dart';

// Importa la estructura principal de la aplicación (Shell con Header, Sidebar/BottomNav y Footer)
import 'screens/app_shell.dart';

/// Función principal de arranque de la aplicación.
///
/// Garantiza la vinculación del motor de Flutter con la plataforma nativa
/// antes de invocar operaciones asíncronas como Firebase.
Future<void> main() async {
  // Asegura que los enlaces de widgets de Flutter estén correctamente inicializados antes de ejecutar código asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase, Firebase Analytics y App Check con manejo seguro de errores
  await FirebaseService.initialize();

  // Infla y monta el widget raíz de la aplicación en el árbol de renderizado
  runApp(const ProveoApp());
}

/// Widget raíz de la aplicación Proveo.
///
/// Configura los proveedores de estado globales, el tema visual y la navegación condicional según el estado de autenticación.
class ProveoApp extends StatelessWidget {
  // Constructor constante con clave de widget para optimización del motor de Flutter
  const ProveoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider permite registrar múltiples ChangeNotifiers accesibles globalmente en el árbol de widgets
    return MultiProvider(
      providers: [
        // Instancia y provee AuthProvider para que cualquier pantalla pueda consultar y mutar el estado del usuario
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      // MaterialApp configura el enrutador, localización, tema y contenedor visual principal
      child: MaterialApp(
        // Oculta el banner de "DEBUG" en la esquina superior derecha para mantener una apariencia limpia y profesional
        debugShowCheckedModeBanner: false,
        // Título de la aplicación que se muestra en pestañas del navegador web y administrador de tareas
        title: 'PROVEO Premium',
        // Aplica el tema visual claro personalizado de Proveo Nicaragua
        theme: AppTheme.light,
        // Consumer escucha cambios en AuthProvider y reconstruye la pantalla inicial de forma reactiva
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // Si el usuario tiene una sesión activa válida (autenticado)
            if (auth.isAuthenticated) {
              // Muestra el cascarón principal de la aplicación con la sesión inyectada
              return AppShell(user: auth.currentUser!);
            }
            // Si no está autenticado, redirige a la pantalla de bienvenida y login
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}

