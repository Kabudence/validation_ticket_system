import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movil_validation_app/core/constants/app_colors.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late ScrollController _scrollController;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    // Ajustar la fecha inicial a la hora local de Perú
    currentDate = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    _scrollController = ScrollController(
      initialScrollOffset: (currentDate.day - 1) * 80, // Ajustar desplazamiento inicial basado en el día actual
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calcular la cantidad de días del mes actual
    final int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

    return Column(
      children: [
        // Navegación entre días del mes actual
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: currentDate.day > 1
                  ? () {
                setState(() {
                  currentDate = currentDate.subtract(const Duration(days: 1)); // Retroceder un día
                });
              }
                  : null, // Desactivar si no se puede retroceder
            ),
            Text(
              DateFormat('MMMM yyyy').format(currentDate), // Mostrar el mes y año actual
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: currentDate.day < daysInMonth
                  ? () {
                setState(() {
                  currentDate = currentDate.add(const Duration(days: 1)); // Avanzar un día
                });
              }
                  : null, // Desactivar si no se puede avanzar
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _scrollController, // Controlador de desplazamiento
            scrollDirection: Axis.horizontal,
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = DateTime(currentDate.year, currentDate.month, index + 1);
              return _DayItem(
                dayName: _getDayName(day.weekday),
                date: day.day,
                isSelected: day.day == currentDate.day, // Día seleccionado
              );
            },
          ),
        ),
      ],
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
              color: isSelected ? AppColors.primaryBlue : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey.shade200,
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
