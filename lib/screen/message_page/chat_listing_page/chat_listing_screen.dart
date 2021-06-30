import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/message_page/chat_listing_page/chat_listing_bloc.dart';
import 'package:motivational_quotes/screen/message_page/chat_listing_page/chat_listing_object.dart';
import 'package:motivational_quotes/screen/message_page/message_screen.dart';

class ChatListingScreen extends StatefulWidget {
  final String token;
  const ChatListingScreen({Key key, @required this.token}) : super(key: key);
  @override
  _ChatListingScreenState createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen>
    with AutomaticKeepAliveClientMixin<ChatListingScreen> {
  ChatListingBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = ChatListingBloc(widget.token);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf3f3),
      // appBar: commonAppBar("Chat list"),
      body: _commentTileWidget(),
      bottomNavigationBar: bottomNavigationBar(context, 4, widget.token),
    );
  }

  Widget _commentTileWidget() {
    return StreamBuilder<List<ChatListingObject>>(
      stream: _bloc.chatListingObject.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<ChatListingObject> list = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: profileImageWidget(
                      profileImageUrl: list[index].friendProfile.imageUrl),
                  title: Text(list[index].friendProfile.name),
                  subtitle: Text(list[index].message),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageScreen(
                                selfToken: widget.token,
                                friendProfile: list[index].friendProfile)));
                  },
                );
              },
              itemCount: list.length);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
