import 'package:flutter/material.dart';

PreferredSizeWidget commonAppBar(String title) {
  return AppBar(
        title: Text(
          "$title",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF907fA4),
      );
}
