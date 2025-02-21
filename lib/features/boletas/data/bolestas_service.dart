import 'package:intl/intl.dart'; // Importa la librería para manejar fechas
import 'package:dio/dio.dart';

import '../../../shared/services/api_service.dart';

class BoletasService {
  final Dio _dio = Api.dio;

  // Método para obtener las boletas en estado "EN PROCESO" y con la fecha actual (usando advanced-search)
  Future<List<dynamic>> getBoletasEnProceso() async {
    try {
      // Obtener la fecha actual en Perú (Zona Horaria: América/Lima)
      String currentDate = DateFormat('yyyy-MM-dd').format(
        DateTime.now().toUtc().add(const Duration(hours: -5)),
      );

      // Parámetros de búsqueda avanzada
      final Map<String, dynamic> params = {
        'fromDate': currentDate,
        'toDate': currentDate, // Asumimos que solo buscas boletas de un solo día
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

  Future<List<dynamic>> getBoletasTodayInProcessPeru({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/ventas/today-inprocess-peru',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
      // Suponiendo que el endpoint devuelve: { "ventas": [...] }
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> ventas = data['ventas'] ?? [];
      return ventas;
    } catch (e) {
      throw Exception('Failed to load today in-process boletas (Peru): $e');
    }
  }

  /// Obtiene la boleta (registro regmovcab) por su ID.
  Future<dynamic> getBoletaById(int id) async {
    try {
      final response = await _dio.get('/regmovcab/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get boleta by ID: $e');
    }
  }

  /// Busca una boleta por el número de documento (num_docum).
  Future<dynamic> searchBoletaByNumDocum(String numDocum) async {
    try {
      final response = await _dio.get('/regmovcab/search/$numDocum');
      return response.data;
    } catch (e) {
      throw Exception('Failed to search boleta by num_docum: $e');
    }
  }

  /// Actualiza el estado a "complete" y actualiza el vendedor para el registro regmovcab.
  /// Se hace una solicitud PUT a /regmovcab/change-state-to-complete/<idmov> con el campo "vendedor" en el body.
  Future<dynamic> changeStateToComplete(int idmov, String vendedor) async {
    try {
      final response = await _dio.put(
        '/regmovcab/change-state-to-complete/$idmov',
        data: {"vendedor": vendedor},
      );
      print(response);
      return response.data;
    } catch (e) {
      throw Exception('Failed to change state to complete: $e');
    }
  }

  /// Obtiene los detalles de movimiento (regmovdet) por idcab usando JOIN para incluir el nombre del producto.
  Future<List<dynamic>> getRegmovdetByIdcab(int idcab) async {
    try {
      final response = await _dio.get('/regmovdet/by-idcab/$idcab');
      return response.data; // Se espera una lista de registros en formato JSON.
    } catch (e) {
      throw Exception('Failed to get regmovdet by idcab: $e');
    }
  }

  /// Sube una foto a la API.
  /// Se usa la ruta '/fotos/upload-photo' que está dentro del mismo prefijo de API.
  Future<dynamic> uploadPhoto(String regmovdetId, String fotoCodigo) async {
    try {
      final response = await _dio.post(
        '/fotos/upload-photo',
        data: {
          "regmovdet_id": regmovdetId,
          "foto_codigo": fotoCodigo,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }
}
