import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue, // Fondo general del contenedor
        borderRadius: BorderRadius.circular(30.0), // Bordes circulares grandes
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("A-", "Letter grade"),
          _buildStatItem("90-92", "Grade %"),
          _buildStatItem("3.7", "GPA"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.6), // Fondo más claro para cada estadística
          borderRadius: BorderRadius.circular(20.0), // Bordes más pequeños para cada tarjeta
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Color del texto principal
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white.withOpacity(0.8), // Color del texto secundario con opacidad
              ),
            ),
          ],
        ),
      ),
    );
  }
}
