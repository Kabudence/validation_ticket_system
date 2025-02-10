import 'package:flutter/material.dart';
import '../../../notification/data/notification_service.dart';
import '../components/profile_header.dart';
import '../components/stats_overview.dart';
import '../components/quick_actions.dart';
import '../components/calendar_widget.dart';
import '../components/schedule_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> _notificaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchNotificaciones(); // Llama al método para actualizar las notificaciones
  }



  Future<void> _fetchNotificaciones() async {
    try {
      List<dynamic> notificaciones = await _notificationService.getNotificationsByState("no_leido");

      setState(() {
        _notificaciones = notificaciones.map((notificacion) {
          return {
            "id": notificacion["id"] ?? 0,
            "descripcion": notificacion["descripcion"] ?? "Descripción no disponible",
            "numdocum": notificacion["numdocum_regmovcab"] ?? "Sin número de documento",
          };
        }).toList();
        _isLoading = false;
      });


    } catch (e) {
      print("Error cargando notificaciones: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBE8FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const ProfileHeader(),
                ),
                Positioned(
                  top: 254,
                  left: 10.0,
                  right: 10.0,
                  child: const QuickActions(),
                ),
                Positioned(
                  top: 340,
                  left: 16.0,
                  right: 16.0,
                  child: const StatsOverview(),
                ),
              ],
            ),
            const SizedBox(height: 47.0),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchNotificaciones,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CalendarWidget(),
                      const SizedBox(height: 10.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0, bottom: 8.0),
                        child: Text(
                          "No Leídos",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _notificaciones.isEmpty
                          ? const Center(
                        child: Text(
                          "No hay notificaciones pendientes",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                          : Column(
                        children: _notificaciones.map((notificacion) {
                          return ScheduleCard(
                            subject: notificacion["numdocum"] ?? "Sin número de documento",
                            status: notificacion["descripcion"].contains("ALERTA") ? "Alerta" : "Venta",
                            time: "Reciente",
                            duration: "No leído",
                          );

                        }).toList(),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF2B2E40),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true, context),
            _buildNavItem(Icons.notifications, 'Notifications', false, context),
            _buildNavItem(Icons.add_a_photo_rounded, 'Ventas Diarias', false, context),
            _buildNavItem(Icons.sticky_note_2, 'Boletas', false, context),

          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Boletas') {
          Navigator.pushNamed(context, '/boletas');
        }  if (label == 'Notifications') {
          Navigator.pushNamed(context, '/notifications');
        } if (label == 'Home') {
          Navigator.pushNamed(context, '/home');
        }if (label == 'Ventas Diarias') {
          Navigator.pushNamed(context, '/ventas_diarias');
        }

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


String extractProductDetails(String message) {
  // Expresión regular para productos modificados
  RegExp productRegex = RegExp(r'([\w\s\d\.\-]+:\s-\d+\.\d+\s+unidades,\s+Stock\s+actual:\s+\d+\.\d+)', multiLine: true);

  // Expresión regular para alertas
  RegExp alertRegex = RegExp(r'ALERTA:.*?\(.*?\)', multiLine: true);

  // Buscar coincidencias de productos modificados
  Iterable<Match> productMatches = productRegex.allMatches(message);

  // Buscar coincidencias de alertas
  Iterable<Match> alertMatches = alertRegex.allMatches(message);

  // Combinar las coincidencias de productos y alertas
  List<String> detalles = [
    ...productMatches.map((match) => match.group(0)!),
    ...alertMatches.map((match) => match.group(0)!)
  ];

  // Unir los detalles en un solo string con saltos de línea
  return detalles.join("\n");
}
