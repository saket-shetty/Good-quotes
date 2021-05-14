import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/login/login_screen.dart';
import 'package:motivational_quotes/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';

class SignInGoogle {
  FirebaseAuth _fAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      User googleuser = (await _fAuth.signInWithCredential(credential)).user;
      await sharedPreferences.setString(
          SharedPreferencesKey.token, googleuser.uid);
      await sharedPreferences.setString(
          SharedPreferencesKey.name, googleuser.displayName);
      await sharedPreferences.setString(
          SharedPreferencesKey.image, googleuser.photoURL);
      await storeProfileDataInFirestore(
          googleuser.uid, googleuser.displayName, googleuser.photoURL);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      print(error);
    }
  }

  Future<void> storeProfileDataInFirestore(
      String token, String name, String imageUrl) async {
    var userDocRef = firebaseFirestore.collection("user").doc(token);
    var doc = await userDocRef.get();
    if (!doc.exists) {
      await userDocRef.set(
        ProfileObject(name, token, imageUrl, 0, null, [], [])
            .toMapLimitedData(),
      );
    } else {
      await userDocRef.update(
        ProfileObject(name, token, imageUrl, 0, null, [], [])
            .toMapLimitedData(),
      );
    }
  }

  Future<void> handleGoogleSignOut() async {
    await _googleSignIn.signOut();
  }

  Future<void> handleLogout(BuildContext context) async {
    await handleGoogleSignOut();
    await sharedPreferences.clear();
        Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
