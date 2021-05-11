import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/add_post/add_post_screen.dart';
import 'package:motivational_quotes/screen/comment_page/comment_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomepageBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = HomepageBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Good quotes",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontFamily: "Lobster",
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF907fA4),
      ),
      bottomNavigationBar: Container(
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
              onPressed: () {},
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
                LineIcons.bookmark,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<PostData>>(
        stream: _bloc.postListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> list = snapshot.data.reversed.toList();
            return ListView.builder(
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textPost(list[index]),
                      iconButtons(list[index]),
                      socialDataMetrics(list[index]),
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

  Widget textPost(PostData postData) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: Color(int.parse(postData.backgroundColor)),
        child: Center(
          child: Text(
            postData.quote,
            style: TextStyle(
              fontSize: postData.fontSize.toDouble(),
              height: 1.6,
              fontFamily: "PlayfairVariable",
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButtons(PostData data) {
    String userToken = sharedPreferences.getString(SharedPreferencesKey.token);
    bool isLiked = data.likes != null && data.likes.contains(userToken);
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
                builder: (context) => CommentScreen(timestamp: data.timestamp),
              ),
            );
          },
        ),
        Expanded(
          child: Container(),
        ),
        IconButton(
          icon: Icon(
            LineIcons.bookmark,
            size: 30,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget socialDataMetrics(PostData data) {
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
                      builder: (context) =>
                          CommentScreen(timestamp: data.timestamp),
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
}
