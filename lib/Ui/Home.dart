import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../API/firebase_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseApi service = FirebaseApi();
  String? token = "";
  String? token2 = "";

  void getToken() async {
    token = await FirebaseApi().firebaseMessaging.getToken() as String?;
    setState(() {
      token2 = token;
    });
  }
  @override
  Widget build(BuildContext context)=>Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    getToken();
                  },
                  icon: Icon(Icons.notifications)),
              SelectableText(token2.toString())
            ],
          )));

}
