import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase/firebase_service.dart';
import 'services/firebase/firestore_repository.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await FirestoreRepository().seedDemoData();
  runApp(const ProveoApp());
}

class ProveoApp extends StatelessWidget {
  const ProveoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PROVEO Premium',
    theme: AppTheme.light,
    home: const SplashScreen(),
  );
}
