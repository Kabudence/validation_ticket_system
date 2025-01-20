import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 60.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Habilitar desplazamiento horizontal
        child: Row(
          children: [
            const SizedBox(width: 12.0), // Espaciado inicial
            _QuickActionItem(
              icon: Icons.rocket_launch,
              label: "Academic success",
              color: const Color(0xFF7D54E0), // Púrpura vibrante (armonizado)
            ),
            _QuickActionItem(
              icon: Icons.menu_book,
              label: "Homework",
              color: const Color(0xFF7056D2), // Púrpura más claro
            ),
            _QuickActionItem(
              icon: Icons.warning,
              label: "Notifications",
              color: const Color(0xFFF4A261), // Naranja más suave
            ),
            _QuickActionItem(
              icon: Icons.person,
              label: "Profile",
              color: const Color(0xFF2E1C9C), // Azul oscuro
            ),
            const SizedBox(width: 12.0), // Espaciado final
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Más espacio superior e inferior
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para cada acción
        borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38, // Ancho del contenedor
            height: 38, // Altura del contenedor
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.0), // Bordes medio redondeados
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Texto en negrita
              color: AppColors.secondBlue.withAlpha(200), // Color secundario con opacidad
            ),
          ),
        ],
      ),
    );
  }
}
