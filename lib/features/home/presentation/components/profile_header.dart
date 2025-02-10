import 'package:flutter/material.dart';
import 'package:movil_validation_app/core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho de la pantalla
      padding: const EdgeInsets.only(top: 20.0, bottom: 140.0),
      decoration: BoxDecoration(
        gradient: AppColors.customGradient, // Gradiente definido en AppColors
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos
        children: [
          // Imagen del perfil
          CircleAvatar(
            radius: 80,
            backgroundImage: const AssetImage('assets/images/login_logo.png'),
            backgroundColor: Colors.white, // Fondo blanco alrededor de la imagen
          ),
          const SizedBox(height: 16.0),
          // Nombre del usuario
          const Text(
            "Madelaine Bustamante",
            style: TextStyle(

              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),

          ),
          // Grado del usuario
          const Text(
            "Gerente general",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),

        ],
      ),
    );
  }
}
