import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(7, (index) {
          final day = DateTime.now().add(Duration(days: index));
          return _DayItem(
            dayName: _getDayName(day.weekday),
            date: day.day,
            isSelected: index == 0, // Marcar el primer día como seleccionado
          );
        }),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days[weekday - 1];
  }
}

class _DayItem extends StatelessWidget {
  final String dayName;
  final int date;
  final bool isSelected;

  const _DayItem({
    Key? key,
    required this.dayName,
    required this.date,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.blue : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
            child: Text(
              "$date",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
