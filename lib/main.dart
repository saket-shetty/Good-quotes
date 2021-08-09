import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_quotes/local_notification/local_notification.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/splash_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

StreamController<List<ProfileObject>> userSearchDetailController =
    BehaviorSubject<List<ProfileObject>>();
SharedPreferences sharedPreferences;
FirebaseFirestore firebaseFirestore;

// local Notification initialization code
LocalNotification localNotification;
// local notification settings ends here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseFirestore = FirebaseFirestore.instance;
  sharedPreferences = await SharedPreferences.getInstance();
  localNotification = new LocalNotification();
  localNotification.initializeLocalNotificationSettings();
  notificationHandler();
  getFCMToken();
  runApp(MyApp());
}

Future<String> getFCMToken() async {
  String fcmToken = await FirebaseMessaging.instance.getToken();
  firebaseFirestore.collection("allUserToken").doc("fcmToken").update({
    "tokens": FieldValue.arrayUnion([fcmToken]),
  });
  print("FCM token $fcmToken");
  return fcmToken;
}

void notificationHandler() {
  FirebaseMessaging.onMessage.listen((snapshot) async {
    //Calls when the app is in foreground and notification is received.
    localNotification.showNotification(snapshot.data);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot) {
    //Calls when the notification is been clicked.
    localNotification.notificationRoute(snapshot.data);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    return;
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
