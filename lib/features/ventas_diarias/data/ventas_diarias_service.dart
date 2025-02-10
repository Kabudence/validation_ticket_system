import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../shared/services/api_service.dart';

class VentasDiariasService {
  final Dio _dio = Api.dio;

  /// Obtiene las boletas en estado COMPLETADO para el día de hoy en hora de Perú.
  Future<List<dynamic>> getBoletasCompletadasHoy() async {
    try {
      final response = await _dio.get('/ventas/today-completed-peru');
      if (response.statusCode == 200) {
        return response.data['ventas'] ?? [];
      } else {
        throw Exception(
            'Error al obtener las boletas completadas: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error en getBoletasCompletadasHoy: $e');
      rethrow;
    }
  }

  /// Obtiene las fotos asociadas a un `idcab` utilizando respuesta en bytes.
  Future<List<dynamic>> getFotosByIdCab(int idcab) async {
    try {
      final response = await _dio.get(
        '/fotos/by-idcab/$idcab',
        options: Options(responseType: ResponseType.bytes),
      );

      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');

      // Decodificamos los bytes a String usando UTF8
      final String decodedResponse = utf8.decode(response.data);
      final preview = decodedResponse.length >= 200 ? decodedResponse.substring(0, 200) : decodedResponse;
      print('Decoded data: $preview ...');

      // Convertimos el String a JSON
      final Map<String, dynamic> data = json.decode(decodedResponse);

      if (response.statusCode == 200) {
        return data['fotos'] ?? [];
      } else {
        throw Exception('Error al obtener las fotos: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error en getFotosByIdCab: $e');
      rethrow;
    }
  }

}
