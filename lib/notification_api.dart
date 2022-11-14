import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description ',
        importance: Importance.max,
      ),
    );
  }

  static Future init({initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: android);

    await _notification.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      onNotifications.add(payload.toString());
    });
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notification.show(
          id,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel id',
              'channel name',
              channelDescription: 'channel description',
              importance: Importance.max,
            ),
          ),
          payload: payload);
}
