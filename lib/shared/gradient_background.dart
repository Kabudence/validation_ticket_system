import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B1B3A), // Azul oscuro
              Color(0xFF512DA8), // Morado intermedio
              Color(0xFF000000), // Negro
            ],
          ),
        ),
      ),
    );
  }
}
