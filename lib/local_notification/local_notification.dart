import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/message_page/message_screen.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';

const String groupKey = 'com.android.example.WORK_EMAIL';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: (i, j, k, l) {
          print("hello world");
          return;
        });

const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails('1', "channel_name", "description",
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

class LocalNotification {
  Future<void> initializeLocalNotificationSettings() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    notificationRoute(jsonDecode(payload));
  }

  void notificationRoute(Map<String, dynamic> data) {
    String selfToken = sharedPreferences.getString(SharedPreferencesKey.token);
    String screen = data["screen"];
    switch (screen) {
      case "chat":
        String friendName = data["name"];
        String friendToken = data["token"];
        String friendImage = data["image"];
        Get.to(() => MessageScreen(
            selfToken: selfToken,
            friendProfile: ProfileObject(friendName, friendToken, friendImage,
                null, null, null, null, null, null)));
        break;
      default:
    }
  }

  showNotification(Map<String, dynamic> payload) async {
    await flutterLocalNotificationsPlugin.show(0, payload["name"],
        payload["message"], firstNotificationPlatformSpecifics,
        payload: jsonEncode(payload));
  }
}
