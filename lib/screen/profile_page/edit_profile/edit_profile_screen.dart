import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';

class EditProfileScreen extends StatefulWidget {
  final String bio;
  final String token;
  const EditProfileScreen({Key key, @required this.bio, @required this.token})
      : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String name = sharedPreferences.getString(SharedPreferencesKey.name);

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _bioController.text = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF907fA4),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              String name = _nameController.text;
              if (name.replaceAll(RegExp(r'/s'), '').length > 0) {
                await firebaseFirestore
                    .collection("user")
                    .doc(widget.token)
                    .update({
                  "user_name": _nameController.text,
                  "status": _bioController.text,
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: profileImageWidget(width: 50),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "name"),
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(labelText: "bio"),
            ),
          ],
        ),
      ),
    );
  }
}
