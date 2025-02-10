import 'package:dio/dio.dart';
import '../../../shared/services/api_service.dart';

class NotificationService {
  final Dio _dio = Api.dio;

  /// Cambia el estado de una notificación a 'leído' por su ID.
  Future<dynamic> markNotificationAsRead(int notificacionId) async {
    try {
      final response = await _dio.put(
        '/notificaciones/$notificacionId/leido',
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Obtiene todas las notificaciones filtradas por estado ('leido' o 'no_leido')
  Future<List<dynamic>> getNotificationsByState(String estado) async {
    try {
      // Validar que el estado sea "leido" o "no_leido"
      if (estado != "leido" && estado != "no_leido") {
        throw Exception("Estado inválido. Debe ser 'leido' o 'no_leido'.");
      }

      final response = await _dio.get(
        '/notificaciones',
        queryParameters: {
          'estado': estado,
        },
      );

      // Extraer la lista de notificaciones del JSON de respuesta
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> notificaciones = data['notificaciones'] ?? [];

      return notificaciones;
    } catch (e) {
      throw Exception('Failed to fetch notifications by state: $e');
    }
  }
}
