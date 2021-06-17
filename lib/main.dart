import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/splash_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

StreamController<List<ProfileObject>> userSearchDetailController =
    BehaviorSubject<List<ProfileObject>>();
SharedPreferences sharedPreferences;
FirebaseFirestore firebaseFirestore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseFirestore = FirebaseFirestore.instance;
  sharedPreferences = await SharedPreferences.getInstance();
  FirebaseFunctions functions = FirebaseFunctions.instance;
  getFCMToken();
  notificationHandler();
  runApp(MyApp());
}

void getFCMToken() async {
  String fcmToken = await FirebaseMessaging.instance.getToken();
  sharedPreferences.setString(SharedPreferencesKey.fcmToken, fcmToken);
}

void notificationHandler() {
  FirebaseMessaging.onMessage.listen((snapshot) {
    var x = snapshot.data;
    print(x);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot) {
    // var x = snapshot.data;
    print("on message open");
  });
  FirebaseMessaging.onBackgroundMessage((message) {
    // var x = message.data;
    print("On background");
    return;
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Good Quotes',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => LoginScreen(),
        "home_page": (context) => HomePage(),
      },
    );
  }
}
