import 'package:intl/intl.dart'; // Importa la librería para manejar fechas
import 'package:dio/dio.dart';

import '../../../shared/services/api_service.dart';

class BoletasService {
  final Dio _dio = Api.dio;

  // Método para obtener las boletas en estado "EN PROCESO" y con la fecha actual
  Future<List<dynamic>> getBoletasEnProceso() async {
    try {
      // Obtener la fecha actual en Perú (Zona Horaria: América/Lima)
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc().add(Duration(hours: -5)));

      // Parámetros de búsqueda avanzada
      final Map<String, dynamic> params = {
        'fromDate': currentDate,
        'toDate': currentDate,  // Asumimos que solo buscas boletas de un solo día
        'status': 'EN PROCESO',
        'limit': 10,
        'offset': 0
      };

      final response = await _dio.get('/ventas/advanced-search', queryParameters: params);
      return response.data['ventas']; // Asumiendo que la respuesta tiene la clave 'ventas'
    } catch (e) {
      throw Exception('Failed to load boletas: $e');
    }
  }
}
