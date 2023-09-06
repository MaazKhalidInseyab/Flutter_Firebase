import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notificationScreen extends StatelessWidget {
  const notificationScreen({Key? key}) : super(key: key);
  static const route = '/notificationScreen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute
        .of(context)!
        .settings
        .arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificationscreen"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("NotificationScreen"),
            Text('{message?.notification?.title}'),
            Text('Body: {message.notification?.body}'),
            Text('Payload: {message.dara}')
          ],
        ),
      ),
    );
  }
}
