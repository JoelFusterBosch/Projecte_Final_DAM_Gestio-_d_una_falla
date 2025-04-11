import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificacionsDatasource {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Inicialització de notificacions
  Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);
  }

  // Funció per a mostrar una notificació
   Future<void> showNotification({
    required String title,
    required String body,
    String? channelId,
    String? channelName,
    String? channelDescription,
    Importance importance = Importance.max,
  }) async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Configuració del canal de notificació
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id', // ID del canal
      'Default Channel', // Nom del canal
      channelDescription: 'Este canal es per a notificacions per defecte', 
      priority: Priority.high, // Prioritat de la notificació
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      0,
      title, // Títol dinàmic
      body,  // Cos dinàmic
      platformDetails,
    );
  }
}
