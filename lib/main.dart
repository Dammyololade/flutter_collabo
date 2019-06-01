import 'dart:io';

import 'package:flutter/material.dart';

import 'AppConfig.dart';
import 'onboarding/LandingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async{

  final FirebaseApp app = await FirebaseApp.configure(
    name: "flutter Collabo",
    options: Platform.isAndroid ? FirebaseOptions(
        googleAppID: "1:667302951716:android:81bf2fe2027efa82",
        apiKey: "AIzaSyDPSq5oa9pttCTOl9sO0xdZlQbNeCVoyrs",
    ) : FirebaseOptions(
        googleAppID: null
    ),
  );
  final Firestore firestore = new Firestore(app: app);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppConfig.APP_PRIMARY_COLOR,
        accentColor: AppConfig.APP_ACCENT_COLOR,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LandingScreen(),
    );
  }
}