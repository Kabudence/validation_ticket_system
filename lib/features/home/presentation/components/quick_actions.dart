import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue, // Fondo principal del contenedor
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Esquina inferior izquierda redondeada
          bottomRight: Radius.circular(20.0), // Esquina inferior derecha redondeada
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Habilitar desplazamiento horizontal
        child: Row(
          children: [
            const SizedBox(width: 12.0), // Espaciado inicial
            _QuickActionItem(
              icon: Icons.rocket_launch,
              label: "Academic success",
              color: Colors.teal,
            ),
            _QuickActionItem(
              icon: Icons.menu_book,
              label: "Homework",
              color: Colors.purple,
            ),
            _QuickActionItem(
              icon: Icons.warning,
              label: "Notifications",
              color: Colors.orange,
            ),
            _QuickActionItem(
              icon: Icons.person,
              label: "Profile",
              color: Colors.blue,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
