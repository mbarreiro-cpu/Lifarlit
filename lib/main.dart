
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/detail_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/online_products_screen.dart';
import 'services/notification_service.dart';
import 'providers/product_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar las notificaciones locales.
  await NotificationService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: const LifarlitApp(),
    ),
  );
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
        '/productos-online': (context) =>
            const OnlineProductsScreen(),
      },
    );
  }
}
