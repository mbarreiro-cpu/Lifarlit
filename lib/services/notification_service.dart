import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Inicializar el servicio de notificaciones.
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );
  }

  // Solicitar permiso para mostrar notificaciones.
  static Future<bool> requestPermission() async {
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final permissionGranted =
        await androidImplementation?.requestNotificationsPermission();

    return permissionGranted ?? true;
  }

  // Mostrar una notificación de prueba.
  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'lifarlit_channel',
      'Notificaciones de Lifarlit',
      channelDescription:
          'Avisos y notificaciones de la aplicación Lifarlit.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id: 1,
      title: '¡Bienvenido a Lifarlit!',
      body: 'Las notificaciones están funcionando correctamente.',
      notificationDetails: notificationDetails,
    );
  }
}