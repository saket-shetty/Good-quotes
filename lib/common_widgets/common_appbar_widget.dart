import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/add_post/add_post_screen.dart';
import 'package:motivational_quotes/screen/comment_page/comment_screen.dart';
import 'package:motivational_quotes/screen/explore_page/explore_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/message_page/chat_tab_screen.dart';
import 'package:motivational_quotes/screen/message_page/message_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_screen.dart';

PreferredSizeWidget commonAppBar(String title, {PreferredSizeWidget tabs}) {
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
    bottom: tabs,
  );
}

Widget bottomNavigationBar(BuildContext context, int tab, String token,
    {ScrollController scrollController}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12, width: 0.5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            LineIcons.home,
            size: 30,
          ),
          onPressed: () {
            if (tab == 1) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          },
        ),
        IconButton(
          icon: Icon(
            LineIcons.compass,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            LineIcons.plusCircle,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            LineIcons.facebookMessenger,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatTabScreen(
                  token: token,
                ),
              ),
            );
          },
        ),
        InkWell(
          child: profileImageWidget(width: 14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userToken: token,
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget textPost(PostData postData, BuildContext context,
    {bool hideHeader = false, bool dynamicWidth = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Visibility(
        visible: !hideHeader,
        child: ListTile(
          leading:
              profileImageWidget(profileImageUrl: postData.postersImageUrl),
          title: Text(
            postData.postersName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF356B8F),
            ),
          ),
          subtitle: Text(postData.postersRole),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userToken: postData.postersId,
                ),
              ),
            );
          },
        ),
      ),
      Card(
        child: Container(
          width: dynamicWidth
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width,
          height: dynamicWidth
              ? (MediaQuery.of(context).size.width / 3) - 8
              : MediaQuery.of(context).size.width,
          color: Color(int.parse(postData.backgroundColor)),
          child: Center(
            child: Text(
              postData.quote,
              style: TextStyle(
                fontSize: dynamicWidth ? 13 : postData.fontSize.toDouble(),
                height: 1.6,
                fontFamily: "PlayfairVariable",
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget socialDataMetrics(PostData data, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: data.likes.length > 0,
          child: Text(
            data.likes.length == 1
                ? "${data.likes.length} like"
                : "${data.likes.length} likes",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Visibility(
          visible: data.commentCount != null && data.commentCount != 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                        timestamp: data.timestamp, postToken: data.postersId),
                  ),
                );
              },
              child: Text(
                data.commentCount == 1
                    ? "view ${data.commentCount} comment"
                    : "view all ${data.commentCount} comments",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget messageWidget(
    MessageObject messageData,
    BuildContext context,
    ScrollController _scrollController,
    String selfToken,
    String friendProfileImageUrl) {
  return messageData.token == selfToken
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
              GestureDetector(
                child: profileImageWidget(
                  profileImageUrl: friendProfileImageUrl,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userToken: messageData.token,
                      ),
                    ),
                  );
                },
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

Widget iconButtons(
    PostData data, String userToken, HomepageBloc _bloc, BuildContext context) {
  bool isLiked = data.likes != null && data.likes.contains(userToken);
  bool isSaved = data.postSavedByUsers != null &&
      data.postSavedByUsers.contains(userToken);
  return Row(
    children: [
      IconButton(
        icon: Icon(
          isLiked ? LineIcons.heartAlt : LineIcons.heart,
          size: 30,
          color: isLiked ? Colors.red : Colors.black,
        ),
        onPressed: () {
          _bloc.likePost(data.timestamp, userToken, isLiked);
        },
      ),
      IconButton(
        icon: Icon(
          LineIcons.alternateComment,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommentScreen(
                  timestamp: data.timestamp, postToken: data.postersId),
            ),
          );
        },
      ),
      Expanded(
        child: Container(),
      ),
      IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : LineIcons.bookmarkAlt,
          size: 30,
        ),
        onPressed: () {
          _bloc.savePost(data.timestamp, userToken, isSaved);
        },
      ),
    ],
  );
}
