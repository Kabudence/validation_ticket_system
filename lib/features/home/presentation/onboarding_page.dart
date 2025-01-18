import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue, // Usamos el color que definimos en app_colors.dart
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              // Imagen en la parte superior
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    'assets/images/font_3.png',
                    fit: BoxFit.contain,
                    height: 400,
                    width: 400,
                  ),
                ),
              ),
              const SizedBox(height: 1.0),
              // Texto principal
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Control everything  anywhere',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 48.0, // Tamaño más grande para asemejar la imagen
                      fontWeight: FontWeight.w800, // Peso más grueso
                      color: Colors.white,
                      fontFamily: 'OpenSans',

                      height: 1.4, // Espaciado entre líneas
                      letterSpacing: 0.5, // Espaciado entre letras
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Botón principal
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Asume que tenemos una ruta para Login
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue, // Texto en azul
                  backgroundColor: Colors.white, // Fondo blanco
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Get started',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,

                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              // Botón de texto
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navegar al login
                },
                child: const Text(
                  'Already have an account? Log in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0, // Ajuste del tamaño de fuente
                    fontWeight: FontWeight.w500, // Peso del texto
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
