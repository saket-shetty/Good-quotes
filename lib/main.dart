import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/message_page/message_screen.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/splash_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants/shared_preferences_key.dart';

StreamController<List<ProfileObject>> userSearchDetailController =
    BehaviorSubject<List<ProfileObject>>();
SharedPreferences sharedPreferences;
FirebaseFirestore firebaseFirestore;
String selfToken = sharedPreferences.getString(SharedPreferencesKey.token);
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

ProfileObject friendProfile;
Map<String, dynamic> notificationPayload;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseFirestore = FirebaseFirestore.instance;
  sharedPreferences = await SharedPreferences.getInstance();
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
  FirebaseMessaging.onMessage.listen((snapshot) async{
    //Calls when the app is in foreground and notification is received.
    notificationPayload = snapshot.data;
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot){
    //Calls when the notification is been clicked.
    notificationPayload = snapshot.data;
    notificationRoute(snapshot.data);
  });
  FirebaseMessaging.onBackgroundMessage((message){
    notificationPayload = message.data;
    return;
  });
}

void notificationRoute(Map<String, dynamic> data) {
  String screen = data["screen"];
  switch (screen) {
    case "chat":
      String friendName = data["name"];
      String friendToken = data["token"];
      String friendImage = data["image"];
      friendProfile = ProfileObject(friendName, friendToken, friendImage, null,
          null, null, null, null, null);
      Get.to(() =>
          MessageScreen(selfToken: selfToken, friendProfile: friendProfile));
      break;
    default:
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Good Quotes',
      home: SplashScreen(data: notificationPayload,),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => LoginScreen(),
        "home_page": (context) => HomePage(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
