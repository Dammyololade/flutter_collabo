import 'dart:io';

import 'package:flutter/material.dart';

import 'onboarding/LandingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async{

  final FirebaseApp app = await FirebaseApp.configure(
    name: "BattleField",
    options: Platform.isAndroid ? FirebaseOptions(
        googleAppID: "1:349148006760:android:2faf0d642a6ab859",
        apiKey: "AIzaSyCfE4pLNHa_oiygeFPb8kwKQB6rLGkgxog",
        databaseURL: "https://battlefield-425ae.firebaseio.com/"
    ) : FirebaseOptions(
        googleAppID: null
    ),
  );

  runApp(MyApp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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