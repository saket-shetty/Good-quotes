import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/message_page/message_bloc.dart';
import 'package:motivational_quotes/screen/message_page/message_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';

class MessageScreen extends StatefulWidget {
  final String selfToken;
  final ProfileObject friendProfile;
  const MessageScreen(
      {Key key, @required this.selfToken, @required this.friendProfile})
      : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageBloc _bloc;
  TextEditingController _messageFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = MessageBloc(widget.selfToken, widget.friendProfile.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf3f3),
      appBar: commonAppBar(widget.friendProfile.name),
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
                        return messageWidget(messageData);
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

  Widget messageWidget(MessageObject messageData) {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
    return messageData.token == widget.selfToken
        ? Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        messageData.message,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFF907fA4),
                      ),
                    ),
                  ),
                ),
                profileImageWidget(),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                profileImageWidget(
                  profileImageUrl: widget.friendProfile.imageUrl,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        messageData.message,
                        style: TextStyle(
                          color: Color(0xFF907fA4),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                await _bloc.sendMessageDataToFireStore(
                  MessageObject(
                    _messageFieldController.text,
                    Timestamp.now().millisecondsSinceEpoch,
                    widget.selfToken,
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
