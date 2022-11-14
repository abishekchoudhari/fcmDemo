import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobili_fcm_demo/pushNotification.dart';
import 'package:overlay_support/overlay_support.dart';

import 'notificationBadge.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    _totalNotifications = 0;
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      print("token is $token");
    });
    registerNotification();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    //await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        img: Image.network('https://picsum.photos/250?image=9'),
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
      if (_notificationInfo != null) {
        // For displaying the notification as an overlay
        showSimpleNotification(
          Text("showsimplenotification"),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_notificationInfo!.body!),
          background: Colors.green,
          duration: Duration(seconds: 2),
        );
      }
    });

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('User granted permission');
    //   // For handling the received notifications
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     // Parse the message received
    //     PushNotification notification = PushNotification(
    //       title: message.notification?.title,
    //       body: message.notification?.body,
    //     );

    //     setState(() {
    //       _notificationInfo = notification;
    //       _totalNotifications++;
    //     });
    //     if (_notificationInfo != null) {
    //       // For displaying the notification as an overlay
    //       showSimpleNotification(
    //         Text(_notificationInfo!.title!),
    //         leading: NotificationBadge(totalNotifications: _totalNotifications),
    //         subtitle: Text(_notificationInfo!.body!),
    //         background: Colors.cyan.shade700,
    //         duration: Duration(seconds: 2),
    //       );
    //     }
    //   });
    // } else {
    //   print('User declined or has not accepted permission');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          const SizedBox(height: 16.0),
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE: ${_notificationInfo!.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'BODY: ${_notificationInfo!.body}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
