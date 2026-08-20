import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase/firebase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/auth_screen_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const ProveoApp());
}

class ProveoApp extends StatelessWidget {
  const ProveoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PROVEO Premium',
        theme: AppTheme.light,
        home: ChangeNotifierProvider(
            create: (_) => AuthScreenViewModel(), child: const AuthScreen()),
      );
}
