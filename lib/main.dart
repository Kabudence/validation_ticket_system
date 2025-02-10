import 'package:flutter/material.dart';
import 'package:movil_validation_app/features/boletas/presentation/pages/boletas_page.dart';
import 'package:movil_validation_app/features/boletas/presentation/pages/completar_venta_page.dart';
import 'package:movil_validation_app/features/home/presentation/pages/home_page.dart';
import 'package:movil_validation_app/features/notification/presentation/pages/notifications_page.dart';
import 'package:movil_validation_app/features/ventas_diarias/presentation/ventas_diarias_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingPage(),
         '/login': (context) => LoginPage(), // Placeholder
         '/home': (context) => const HomePage(), // Placeholder
         '/boletas': (context) =>BoletasPage(),
         '/notifications': (context) =>NotificationsPage(),
         '/ventas_diarias': (context) =>VentasDiariasPage(),
        // Placeholder
      },
    );
  }
}
