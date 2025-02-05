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
      backgroundColor: const Color(0xFFDBE8FF), // Fondo azul claro
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior con superposición
            Stack(
              clipBehavior: Clip.none, // Permite que los widgets se salgan del Stack
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: const ProfileHeader(),
                ),
                Positioned(
                  top: 290, // Ajusta la posición vertical de QuickActions
                  left: 10.0,
                  right: 10.0,
                  child: const QuickActions(), // Acciones rápidas como elemento flotante
                ),
                Positioned(
                  top: 380, // Controla la superposición de StatsOverview
                  left: 16.0,
                  right: 16.0,
                  child: const StatsOverview(), // Contenedor de estadísticas
                ),
              ],
            ),
            const SizedBox(height: 47.0), // Espaciado entre StatsOverview y el siguiente bloque
            // Sección inferior con scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CalendarWidget(), // Calendario
                    const SizedBox(height: 10.0),
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
          color: const Color(0xFF2B2E40), // Azul oscuro para la barra inferior
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true, context),
            _buildNavItem(Icons.dashboard, 'Dashboard', false, context),
            _buildNavItem(Icons.notifications, 'Notifications', false, context),
            _buildNavItem(Icons.sticky_note_2, 'Boletas', false, context),
          ],
        ),
      ),
    );
  }

  // Método para construir cada botón de navegación inferior
  Widget _buildNavItem(IconData icon, String label, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Boletas') {
          Navigator.pushNamed(context, '/boletas'); // Navega a la ruta 'boletas'
        }
        // Puedes agregar más condiciones para otras rutas
      },
      child: Column(
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
      ),
    );
  }
}
