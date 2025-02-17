import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String baseUrl = "https://web-production-927a.up.railway.app/api"; // Cambia el URL base si es necesario

  static final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: 90000),
    receiveTimeout: const Duration(milliseconds: 90000),
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Recuperar el token de SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('authToken');

        if (token != null) {
          // Agregar el header Authorization con el formato Bearer
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },
      // Puedes agregar onResponse y onError según necesites
    ));
}
