import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);

    // Primera curva
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.85, // Punto de control
      size.width * 0.5, size.height * 0.8,  // Punto final
    );

    // Segunda curva
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.75, // Punto de control
      size.width, size.height * 0.9, // Punto final
    );

    path.lineTo(size.width, 0); // Línea superior
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
