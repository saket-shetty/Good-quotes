import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/splash_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;
FirebaseFirestore firebaseFirestore;
StreamController<List<ProfileObject>> userSearchDetailController =
    BehaviorSubject<List<ProfileObject>>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseFirestore = FirebaseFirestore.instance;
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
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
