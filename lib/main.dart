import 'package:flutter/material.dart';

import 'screens/detail_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  runApp(const LifarlitApp());
}

class LifarlitApp extends StatelessWidget {
  const LifarlitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifarlit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      routes: {
        '/detalle': (context) => const DetailScreen(),
      },
    );
  }
}