import 'package:flutter/material.dart';
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
         '/login': (context) => const LoginPage(), // Placeholder
      },
    );
  }
}
