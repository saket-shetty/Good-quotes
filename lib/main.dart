import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;
FirebaseFirestore firebaseFirestore;

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
    );
  }
}
