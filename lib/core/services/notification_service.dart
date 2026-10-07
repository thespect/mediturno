import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  });
  Future<void> cancelReminder(int id);
}

class LocalNotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('[NotificationService] Notificaciones en Web no disponibles de manera nativa.');
      _isInitialized = true;
      return;
    }

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('[NotificationService] Tapped notification: ${response.payload}');
        },
      );
      _isInitialized = true;
      debugPrint('[NotificationService] Inicializado correctamente.');
    } catch (e) {
      debugPrint('[NotificationService] Error al inicializar notificaciones: $e');
    }
  }

  @override
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();
    if (kIsWeb) {
      debugPrint('[NotificationService - Instant Web Mock] $title: $body');
      return;
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'mediturno_reminders',
        'Recordatorios de Citas',
        channelDescription: 'Notificaciones sobre citas médicas programadas',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('[NotificationService] Error enviando notificación instantánea: $e');
    }
  }

  @override
  Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!_isInitialized) await initialize();

    debugPrint('[NotificationService] Programando recordatorio ID $id para: $scheduledDate ($title)');
  }

  @override
  Future<void> cancelReminder(int id) async {
    if (kIsWeb) return;
    try {
      await _notificationsPlugin.cancel(id: id);
      debugPrint('[NotificationService] Recordatorio cancelado ID: $id');
    } catch (e) {
      debugPrint('[NotificationService] Error cancelando recordatorio: $e');
    }
  }
}
