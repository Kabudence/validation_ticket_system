import 'package:flutter/material.dart';
import '../../../notification/data/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> _notificaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllNotifications();
  }

  Future<void> _fetchAllNotifications() async {
    try {
      final leidas = await _notificationService.getNotificationsByState("leido");
      final noLeidas = await _notificationService.getNotificationsByState("no_leido");

      setState(() {
        // Asignar estado "leido" o "no_leido" manualmente y manejar valores nulos
        _notificaciones = [
          ...noLeidas.map((n) => {
            ...n,
            "estado": "no_leido",
            "descripcion": n["descripcion"] ?? "Descripción no disponible",
            "numdocum_regmovcab": n["numdocum_regmovcab"] ?? "SIN_DOC",
          }),
          ...leidas.map((n) => {
            ...n,
            "estado": "leido",
            "descripcion": n["descripcion"] ?? "Descripción no disponible",
            "numdocum_regmovcab": n["numdocum_regmovcab"] ?? "SIN_DOC",
          }),
        ];
        _isLoading = false;
      });
    } catch (e) {
      print("Error cargando notificaciones: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int notificacionId) async {
    try {
      await _notificationService.markNotificationAsRead(notificacionId);
      _fetchAllNotifications(); // Refrescar la lista después de marcar como leído
    } catch (e) {
      print("Error al marcar como leído: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBE8FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Altura estándar del AppBar
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E1C9C), // Azul más oscuro
                Color(0xFFA16EFF), // Lavanda claro
              ],
            ),
          ),
          child: AppBar(
            title: const Text(
              "Notificaciones",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent, // Fondo transparente para mostrar el gradiente
            elevation: 0, // Eliminar la sombra
            iconTheme: const IconThemeData(color: Colors.white), // Íconos en blanco
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notificaciones.isEmpty
            ? const Center(
          child: Text(
            "No hay notificaciones",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _notificaciones.length,
          itemBuilder: (context, index) {
            final notificacion = _notificaciones[index];
            final isLeido = notificacion["estado"] == "leido";
            final descripcion = notificacion["descripcion"] ?? "";
            final numdocum = notificacion["numdocum_regmovcab"] ?? "SIN_DOC";

            // Verificar si es una alerta
            final isAlerta = descripcion.contains("ALERTA");

            return GestureDetector(
              onTap: isLeido
                  ? null // No hacer nada si ya está leído
                  : () => _markAsRead(notificacion["id"]),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isAlerta
                      ? Colors.red[100] // Fondo rojo claro para alertas
                      : (isLeido
                      ? Colors.grey[300] // Fondo gris claro para leídas
                      : Colors.white), // Fondo blanco para no leídas
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
                      isAlerta
                          ? Icons.warning // Ícono de advertencia para alertas
                          : (isLeido ? Icons.check_circle : Icons.notifications),
                      color: isAlerta
                          ? Colors.red // Ícono rojo para alertas
                          : (isLeido ? Colors.green : Colors.blue),
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1) Título: numdocum_regmovcab
                          Text(
                            numdocum,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isAlerta
                                  ? Colors.red[900]
                                  : (isLeido ? Colors.black54 : Colors.black),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 2) Descripción
                          Text(
                            descripcion,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isAlerta
                                  ? Colors.red[900]
                                  : (isLeido ? Colors.black54 : Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 3) ALERTA / "Leído" / "No leído"
                          Text(
                            isAlerta ? "ALERTA" : (isLeido ? "Leído" : "No leído"),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isAlerta
                                  ? Colors.red
                                  : (isLeido ? Colors.black54 : Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Flecha solo para "no leído" que no sea alerta
                    if (!isLeido && !isAlerta)
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 16,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
