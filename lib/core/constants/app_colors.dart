import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF7D54E0); // Púrpura vibrante
  static const Color secondBlue = Color(0xFF2B2E40); // Azul oscuro

  // Gradiente híbrido
  static const Gradient redPurpleGradient = LinearGradient(
    colors: [
      Color(0xFF3A1C71), // Azul oscuro
      Color(0xFFD76D77), // Púrpura
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient customGradient = LinearGradient(
    colors: [
      Color(0xFF2E1C9C), // Azul más oscuro
      Color(0xFFA16EFF), // Azul/púrpura claro más brillante
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient buttomGradient = LinearGradient(
    colors: [
      Color(0xFF2B1B5A), // Azul más oscuro
      Color(0xFF1F1147), // Azul/púrpura claro más brillante
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


}
