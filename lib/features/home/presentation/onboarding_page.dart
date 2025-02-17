import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.customGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img_fount.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                        fontSize: 48.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        height: 1.4,
                        letterSpacing: 0.5,
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
                    foregroundColor: const Color(0xFF2E1C9C), // Texto en azul oscuro del gradiente
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
      ),
    );
  }
}
