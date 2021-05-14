import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';

Widget profileImageWidget(
    {String profileImageUrl, double width, bool isSquareImage = false}) {
  if (profileImageUrl == null || profileImageUrl == "") {
    profileImageUrl = sharedPreferences.getString(SharedPreferencesKey.image);
  }
  if (isSquareImage) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Color(0xFF907fA4)),
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFF907fA4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          width: 120,
          height: 120,
          imageUrl: profileImageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
  return CircleAvatar(
    radius: width ?? 20,
    backgroundImage: CachedNetworkImageProvider(profileImageUrl),
  );
}
