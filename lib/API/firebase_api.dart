import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase/Ui/Dashboard.dart';
import 'package:flutter_firebase/Ui/Home.dart';
import 'package:flutter_firebase/Ui/notification_screen.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  //creating firebase_messaging instance
  final firebaseMessaging = FirebaseMessaging.instance;

  //creating instance for local notifications plugin
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'high_importance_notifications',
      description: 'this channel is used for important notifications',
      importance: Importance.max);

  Future<void> initNotifications() async {
    //ask for permission for notifications upon app installation
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true,
    );
    final token = await firebaseMessaging.getToken(); //generating token
    print('Token $token');
    initPushNotifications(); //calling push notification method
    initLocalNotifications(); //calling local notifications method
  }

//handler for notification actions
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    if (message.data['type'] == 'notificationscreen') {
      navigatorKey.currentState
          ?.pushNamed(notificationScreen.route, arguments: message);
    } else if (message.data['type'] == 'dashboard') {
      navigatorKey.currentState?.pushNamed(Dashboard.route, arguments: message);
    }
  }

////for handling push notifications(notifications from firebase)
  void initPushNotifications() async {
    //for apple only
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //when the app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    //when app is opened from background position
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    //setting handler for when app is opened when in background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    /////////////////////For handling notifications in foreground "flutter_local_notifications plugin is required"
//to implement local notifications, we need to define channel and details for notifications and initialize them
    //this method is called whenever the app receives a notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
//for local notification i.e. foreground notifications
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id.toString(), androidChannel.name.toString(),
                  channelDescription: androidChannel.description.toString(),
                  icon: '@drawable/ic_launcher',
                  importance: Importance.high,
                  priority: Priority.high,
                  ticker: 'ticker')),
          payload: jsonEncode(message.toMap()));
    });

  }

////for handling local notifications
  void initLocalNotifications() async {
    print("running");
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      print('converted ${message.data}');
      handleMessage(message);
    });
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }
}
