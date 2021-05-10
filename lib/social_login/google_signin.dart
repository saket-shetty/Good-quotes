import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';

class SignInGoogle{
  FirebaseAuth _fAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();


  Future handleGoogleSignIn(BuildContext context) async{
    try{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      User googleuser = (await _fAuth.signInWithCredential(credential)).user;
      sharedPreferences.setString(SharedPreferencesKey.token,googleuser.uid);
      sharedPreferences.setString(SharedPreferencesKey.name,googleuser.displayName);
      sharedPreferences.setString(SharedPreferencesKey.image,googleuser.photoURL);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }catch (error){
      print(error);
    }
  }

  handleGoogleSignOut() {
    _googleSignIn.signOut();
  }
  
}