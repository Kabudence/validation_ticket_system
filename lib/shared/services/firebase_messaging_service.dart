// lib/features/notification/data/datasources/firebase_messaging_service.dart
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Dio _dio;

  FirebaseMessagingService(this._dio);

  Future<void> initialize() async {
    await _setupFCM();
    _configureMessageHandlers();
  }

  Future<void> _setupFCM() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true,
      );

      debugPrint('Permisos: ${settings.authorizationStatus}');

      final String? token = await _firebaseMessaging.getToken();
      if (token != null) await _registerFCMToken(token);

      _firebaseMessaging.onTokenRefresh.listen(_registerFCMToken);
    } catch (e) {
      debugPrint('Error configurando FCM: $e');
    }
  }

  Future<void> _registerFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'usuario_temporal';

      await _dio.post(
        '/user-token/',
        data: {'username': username, 'fcm_token': token},
      );

      debugPrint('✅ Token registrado');
    } on DioException catch (e) {
      debugPrint('❌ Error token: ${e.response?.data}');
    }
  }

  void _configureMessageHandlers() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Notificación recibida: ${message.notification?.title}');
      // Implementar lógica de notificaciones en primer plano
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('App abierta desde notificación: ${message.data}');
    });
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint('Mensaje en background: ${message.messageId}');
  }
}