import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../shared/services/api_service.dart';

class VentasDiariasService {
  final Dio _dio = Api.dio;

  // Método ya existente para obtener boletas
  Future<List<dynamic>> getBoletasCompletadasHoy() async {
    try {
      final response = await _dio.get('/ventas/today-completed-peru');
      if (response.statusCode == 200) {
        return response.data['ventas'] ?? [];
      } else {
        throw Exception('Error al obtener las boletas completadas: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error en getBoletasCompletadasHoy: $e');
      rethrow;
    }
  }

  /// Nuevo método para obtener las fotos usando paginación.
  Future<List<dynamic>> getFotosByIdCabWithPagination(int idcab, int offset, int limit) async {
    try {
      final response = await _dio.get(
        '/fotos/by-idcab/$idcab?offset=$offset&limit=$limit',
        options: Options(responseType: ResponseType.bytes),
      );

      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');

      final String decodedResponse = utf8.decode(response.data);
      final preview = decodedResponse.length >= 200 ? decodedResponse.substring(0, 200) : decodedResponse;
      print('Decoded data (preview): $preview ...');

      final Map<String, dynamic> data = json.decode(decodedResponse);
      if (response.statusCode == 200) {
        return data['fotos'] ?? [];
      } else {
        throw Exception('Error al obtener las fotos: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error en getFotosByIdCabWithPagination: $e');
      rethrow;
    }
  }
}
