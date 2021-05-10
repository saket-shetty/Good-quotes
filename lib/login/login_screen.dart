import 'package:flutter/material.dart';
import 'package:motivational_quotes/constants/icon_constants.dart';
import 'package:motivational_quotes/social_login/google_signin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              child: Image.asset(
                "assets/icon.png",
                width: IconConstants.iconSize,
                height: IconConstants.iconSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      SignInGoogle().handleGoogleSignIn(context);
                    },
                    child: Image.asset(
                      "assets/google.png",
                      width: IconConstants.socialIconSize,
                      height: IconConstants.socialIconSize,
                    ),
                  ),
                  Image.asset(
                    "assets/facebook.png",
                    width: IconConstants.socialIconSize,
                    height: IconConstants.socialIconSize,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
