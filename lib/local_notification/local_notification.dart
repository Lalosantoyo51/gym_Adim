import 'package:administrador/config/router/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static Future<void> requesPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugins = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugins
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugins = FlutterLocalNotificationsPlugin();
    const initializationsAndroidSettings =
        AndroidInitializationSettings("app_icon");

    const initializationSettings = InitializationSettings(
      android: initializationsAndroidSettings,
    );
    await flutterLocalNotificationsPlugins.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void showLocalNotification({
    required int id,
    String? titulo,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
        "channelId", "channelName",
        playSound: true, priority: Priority.max, importance: Importance.max);

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(id, titulo, body, notificationDetails,
        payload: data);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    router.push(
      "/details/${response.payload}",
    );
  }
}
