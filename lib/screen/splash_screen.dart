import 'package:flutter/material.dart';
import 'package:motivational_quotes/constants/icon_constants.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token;
  double iconSize = IconConstants.iconSize;
  @override
  void initState() {
    super.initState();
    token = sharedPreferences.getString(SharedPreferencesKey.token);
    Future.delayed(Duration(seconds: 2), () {
      if (token != null && token.isNotEmpty) {
        //Navigate to home page;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        //Navigate to login page;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/background_img.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 200.0),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                child: Image.asset(
                  "assets/icon.png",
                  width: iconSize,
                  height: iconSize,
                ),
                duration: Duration(seconds: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
