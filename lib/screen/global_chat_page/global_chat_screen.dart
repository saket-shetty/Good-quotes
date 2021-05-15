import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/message_page/message_bloc.dart';
import 'package:motivational_quotes/screen/message_page/message_object.dart';

class GlobalChatScreen extends StatefulWidget {
  final String token;
  const GlobalChatScreen({Key key, @required this.token}) : super(key: key);
  @override
  _GlobalChatScreenState createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  TextEditingController _messageFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String image = sharedPreferences.getString(SharedPreferencesKey.image);

  MessageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MessageBloc(widget.token, null, globalChat: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar("Global Chat"),
      backgroundColor: Color(0xFFfaf3f3),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: StreamBuilder<List<MessageObject>>(
                stream: _bloc.messageListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MessageObject> list = snapshot.data;
                    return ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (_, index) {
                        MessageObject messageData = list[index];
                        return messageWidget(
                            messageData,
                            context,
                            _scrollController,
                            widget.token,
                            messageData.imageUrl);
                      },
                      itemCount: list.length,
                    );
                  } else {
                    return Center(child: Text("No messages found"));
                  }
                },
              ),
            ),
          ),
          _bottomTextField(),
        ],
      ),
    );
  }

  Widget _bottomTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFf4eee8),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100.0,
        ),
        child: TextFormField(
          controller: _messageFieldController,
          textAlignVertical: TextAlignVertical.center,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Add a comment...",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: profileImageWidget(),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                await _bloc.sendGlobalMessageDataToFireStore(
                  MessageObject(
                    _messageFieldController.text,
                    Timestamp.now().millisecondsSinceEpoch,
                    widget.token,
                    imageUrl: image,
                  ),
                );
                _messageFieldController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }
}
