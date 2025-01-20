import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movil_validation_app/core/constants/app_colors.dart'; // Necesario para formatear la fecha

class ScheduleCard extends StatelessWidget {
  final String time;
  final String subject;
  final String teacher;
  final String duration;

  const ScheduleCard({
    Key? key,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configurar la zona horaria de Perú
    final DateTime now = DateTime.now().toUtc().subtract(const Duration(hours: 5)); // UTC - 5
    final String todayDate = DateFormat('EEEE, d MMMM').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título con la fecha de hoy
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 8.0),
          child: Text(
            todayDate,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        // Tarjeta de horario
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.book, color: AppColors.primaryBlue, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$duration min",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
