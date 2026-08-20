import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase/firebase_service.dart';
import 'screens/auth_screen.dart';
import 'core/providers/auth_provider.dart';
import 'screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const ProveoApp());
}

class ProveoApp extends StatelessWidget {
  const ProveoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PROVEO Premium',
        theme: AppTheme.light,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return AppShell(user: auth.currentUser!);
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
