import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String time;
  final String subject; // Esto ahora será `numdocum`
  final String status; // "Alerta" o estado general
  final String duration;

  const ScheduleCard({
    Key? key,
    required this.time,
    required this.subject,
    required this.status,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAlert = status.toLowerCase() == "alerta";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
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
          Icon(
            isAlert ? Icons.error : Icons.book,
            color: isAlert ? Colors.red : Colors.blue,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject, // Mostramos el `numdocum`
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  status, // "Alerta" o estado general
                  style: TextStyle(
                    fontSize: 14,
                    color: isAlert ? Colors.red : Colors.black54,
                    fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
                  ),
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
                duration,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
