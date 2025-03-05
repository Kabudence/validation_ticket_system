import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkAuthStatus(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Verifica si hay un token y rol almacenados
    final String? token = await storage.read(key: 'jwt_token');
    final String? role = prefs.getString('role');

    await Future.delayed(const Duration(seconds: 2)); // Simula carga

    if (token != null && role != null) {
      // Redirige según el rol
      Navigator.pushReplacementNamed(
          context,
          role == 'admin' ? '/home' : '/boletas'
      );
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuthStatus(context),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}