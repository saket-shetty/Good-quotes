import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<List<PostData>>(
        stream: _bloc.postListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostData> list = snapshot.data;
            return ListView.builder(
              itemBuilder: (_, index) {
                String quote = list[index].quote.replaceAll("\\n", "\n");
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textPost(quote),
                      iconButtons(),
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

  Widget textPost(String quote) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: Colors.red.shade50,
        child: Center(
          child: Text(
            quote,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              fontFamily: "PlayfairVariable",
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButtons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            LineIcons.heart,
            size: 30,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            LineIcons.alternateComment,
            size: 30,
          ),
          onPressed: () {},
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
            visible: data.likesCount != null && data.likesCount != 0,
            child: Text(
              data.likesCount == 1
                  ? "${data.likesCount} like"
                  : "${data.likesCount} likes",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Visibility(
            visible: data.commentCount != null && data.commentCount != 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
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
        ],
      ),
    );
  }
}
