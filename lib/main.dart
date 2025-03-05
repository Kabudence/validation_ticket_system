import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:movil_validation_app/features/boletas/presentation/pages/boletas_page.dart';
import 'package:movil_validation_app/features/home/presentation/pages/home_page.dart';
import 'package:movil_validation_app/features/notification/presentation/pages/notifications_page.dart';
import 'package:movil_validation_app/features/ventas_diarias/presentation/ventas_diarias_page.dart';
import 'package:movil_validation_app/shared/services/api_service.dart';
import 'package:movil_validation_app/shared/services/firebase_messaging_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: SplashScreen()));

  // Inicialización en background
  _initializeApp().then((_) {
    runApp(const MyApp());
  }).catchError((error) {
    debugPrint('Error crítico: $error');
    runApp(const ErrorApp());
  });
}

Future<void> _initializeApp() async {
  await Firebase.initializeApp();
  final messagingService = FirebaseMessagingService(Api.dio);
  await messagingService.initialize();
  FirebaseMessaging.onBackgroundMessage(FirebaseMessagingService.backgroundHandler);
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error al inicializar la app'),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Reintentar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const OnboardingPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
        '/boletas': (context) => BoletasPage(),
        '/notifications': (context) => NotificationsPage(),
        '/ventas_diarias': (context) => VentasDiariasPage(),
      },
    );
  }
}