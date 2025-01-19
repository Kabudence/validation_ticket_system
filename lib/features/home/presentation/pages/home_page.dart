import 'package:flutter/material.dart';
import '../components/profile_header.dart';
import '../components/stats_overview.dart';
import '../components/quick_actions.dart';
import '../components/calendar_widget.dart';
import '../components/schedule_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior con superposición
            Stack(
              clipBehavior: Clip.none, // Permite que los widgets se salgan del Stack
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeader(), // Header del perfil
                    Container(
                      margin: const EdgeInsets.only(bottom: 30.0),
                      child: const QuickActions(), // Acciones rápidas
                    ),
                  ],
                ),
                Positioned(
                  top: 404, // Controla la superposición de StatsOverview
                  left: 16.0,
                  right: 16.0,
                  child: const StatsOverview(), // Contenedor de estadísticas
                ),
              ],
            ),
            const SizedBox(height: 105.0), // Espaciado entre StatsOverview y el siguiente bloque
            // Sección inferior con scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CalendarWidget(), // Calendario
                    const SizedBox(height: 20.0),
                    const ScheduleCard(
                      subject: 'Biology',
                      teacher: 'Floyd Miles',
                      time: '07:00 - 07:45',
                      duration: '15 min',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF5567FF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.dashboard, 'Dashboard', false),
            _buildNavItem(Icons.notifications, 'Notifications', false),
          ],
        ),
      ),
    );
  }

  // Método para construir cada botón de navegación inferior
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
          size: 28.0,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
