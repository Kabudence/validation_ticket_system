import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // static const String baseUrl = "https://web-production-927a.up.railway.app/api";
  static const String baseUrl = "http://10.0.2.2:5000/api"; // Cambiar solo aquí cuando cambie el URL base

  static final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: 90000),
    receiveTimeout: const Duration(milliseconds: 90000),
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Antes de enviar la petición, agregar el header Authorization con el token
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
