

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Ui/Dashboard.dart';
import 'package:flutter_firebase/Ui/notification_screen.dart';

import 'API/firebase_api.dart';
import 'Ui/Home.dart';

final navigatorKey=GlobalKey<NavigatorState>();
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await  FirebaseApi().initNotifications();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const Home(),
      routes: {
        notificationScreen.route:(context)=>const notificationScreen(),
        Dashboard.route:(context)=>const Dashboard(),

      },
    );
  }
}

