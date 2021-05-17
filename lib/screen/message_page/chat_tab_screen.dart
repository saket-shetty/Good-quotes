import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/screen/global_chat_page/global_chat_screen.dart';
import 'package:motivational_quotes/screen/message_page/chat_listing_page/chat_listing_screen.dart';

class ChatTabScreen extends StatefulWidget {
  final String token;
  const ChatTabScreen({Key key, @required this.token}) : super(key: key);
  @override
  _ChatTabScreenState createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: commonAppBar("Chat", tabs: tabs()),
        body: TabBarView(
          children: [
            ChatListingScreen(token: widget.token),
            GlobalChatScreen(token: widget.token)
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget tabs() {
    return TabBar(
      tabs: [
        Tab(
          text: "Chat",
        ),
        Tab(
          text: "Global",
        ),
      ],
    );
  }
}
