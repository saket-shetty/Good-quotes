import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';

class DiaryScreen extends StatefulWidget {
  final String token;
  const DiaryScreen({Key key, @required this.token}) : super(key: key);
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  String image = sharedPreferences.getString(SharedPreferencesKey.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf3f3),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              userGreeting(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 3.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF356B8F),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "My Story",
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF356B8F),
                fontFamily: "Opensans",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          child: profileImageWidget(isSquareImage: true),
        ),
      ],
    );
  }

  // Widget diaryCard(String date, String time, String expanded) {}
}
