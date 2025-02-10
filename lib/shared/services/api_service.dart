import 'package:dio/dio.dart';

class Api {
  static const String baseUrl = "http://10.0.2.2:5000/api"; // Cambiar solo aquí cuando cambie el URL base
  static final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(milliseconds: 90000),
    receiveTimeout: Duration(milliseconds: 90000),
  ));
}
