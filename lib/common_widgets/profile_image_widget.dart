import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';

Widget profileImageWidget({String profileImageUrl, double width}) {
  if (profileImageUrl == null || profileImageUrl == "") {
    profileImageUrl = sharedPreferences.getString(SharedPreferencesKey.image);
  }
  return CircleAvatar(
    radius: width ?? 20,
    backgroundImage: CachedNetworkImageProvider(profileImageUrl),
  );
}
