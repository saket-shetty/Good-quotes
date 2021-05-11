import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/add_post/configure_post_screen.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String name = sharedPreferences.getString(SharedPreferencesKey.name);
  final formKey = new GlobalKey<FormState>();
  TextEditingController postMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double keyboardheight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: commonAppBar("add post"),
      body: new Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    '$name',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              new Container(
                height: deviceheight - keyboardheight - 200,
                child: TextFormField(
                  controller: postMessageController,
                  cursorColor: Colors.deepPurpleAccent,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  scrollPadding: const EdgeInsets.all(20.0),
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                  autofocus: true,
                  decoration: new InputDecoration(errorMaxLines: 3),
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  validator: (val) =>
                      val.length < 1 ? 'please enter message' : null,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 26.0),
              ),
              InkWell(
                onTap: () {
                  _submit();
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFF907fA4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LineIcons.alternatePencil,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConfigurePostScreen(postData: postMessageController.text),
        ),
      );
    }
  }
}
