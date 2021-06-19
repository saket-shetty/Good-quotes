import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/comment_page/comment_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class SavedPostScreen extends StatefulWidget {
  @override
  _SavedPostScreenState createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  String userToken = sharedPreferences.getString(SharedPreferencesKey.token);

  HomepageBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = HomepageBloc.savedPost(userToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar("Saved Post"),
      body: StreamBuilder<List<PostData>>(
        stream: _bloc.postListSavedStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> list = snapshot.data.reversed.toList();
            return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textPost(list[index], context),
                      iconButtons(list[index]),
                      socialDataMetrics(list[index], context),
                    ],
                  ),
                );
              },
              itemCount: list.length,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget iconButtons(PostData data) {
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
                builder: (context) => CommentScreen(timestamp: data.timestamp, postToken: data.postersId),
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
}
