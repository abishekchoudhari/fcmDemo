import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobili_fcm_demo/notification_api.dart';

import 'pushNotification.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();
  PushNotification notification = PushNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    img: Image.network('https://picsum.photos/250?image=9'),
  );

  NotificationApi.showNotification(
      title: 'title', body: message.notification!.body, payload: 'sarah.abs');

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Demo',
      theme: ThemeData(
        // This is the theme
        // of your application.
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     notification();
  //   });
  // }

  @override
  void initState() {
    // var initilazationSettingandroid =
    //     const AndroidInitializationSettings('ic_launcher_round');

    // var initializationSettings =
    //     InitializationSettings(android: initilazationSettingandroid);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    NotificationApi.init();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      print("token is $token");
    });
    //notification();
    super.initState();
    //notification();
    //listenNotifications();
  }

  /* void notification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        img: Image.network('https://picsum.photos/250?image=9'),
      );

      setState(() {
        _notificationInfo = notification;
      });
    });
    print('${_notificationInfo!.body}, ${_notificationInfo!.title}');

    // NotificationApi.showNotification(
    //     title: 'title', body: _notificationInfo!.body, payload: 'sarah.abs');
  } */

  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen((onClickedNotification));

  // void onClickedNotification(String? payload) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            onPressed: () => {},
            child: const Text('simple notification'),
          )
        ]),
      ),
    );
  }
}
