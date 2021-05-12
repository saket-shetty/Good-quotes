import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/add_post/add_post_screen.dart';
import 'package:motivational_quotes/screen/comment_page/comment_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomepageBloc _bloc;
  ScrollController _scrollController = ScrollController();
  TextEditingController _userNameSearchController = TextEditingController();
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFfaf3f3),
        resizeToAvoidBottomInset: false,
        appBar: appBarWidget(),
        bottomNavigationBar: bottomNavigationBar(),
        body: ListView(
          controller: _scrollController,
          children: [
            userGreetingCard(),
            searchUserBox(),
            StreamBuilder<List<PostData>>(
              stream: _bloc.postListStream,
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
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBarWidget() {
    return AppBar(
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
    );
  }

  Widget bottomNavigationBar() {
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
              _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          IconButton(
            icon: Icon(
              LineIcons.facebookMessenger,
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
    );
  }

  Widget userGreetingCard() {
    String userName = sharedPreferences.getString(SharedPreferencesKey.name);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                userName.split(" ").first + "!",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Opensans",
                ),
              ),
            ],
          ),
          profileImageWidget(width: 35),
        ],
      ),
    );
  }

  Widget searchUserBox() {
    return Stack(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black12, width: 0.5),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  child: Icon(EvaIcons.search),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFFfaf3f3),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _userNameSearchController,
                    onChanged: (user) {
                      _bloc.searchUserFromFirestore(user);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "Search friend",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _userNameSearchController.clear();
                          userSearchDetailController.sink.add([]);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 20),
          child: StreamBuilder<List<ProfileObject>>(
              stream: userSearchDetailController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProfileObject> list = snapshot.data;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        ProfileObject user = list[index];
                        return ListTile(
                          leading: profileImageWidget(
                            profileImageUrl: user.imageUrl,
                          ),
                          title: Text(user.name),
                          subtitle: Text("member"),
                        );
                      },
                      itemCount: list.length,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ],
    );
  }

  Widget textPost(PostData postData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          leading: profileImageWidget(profileImageUrl: postData.imageLink),
          title: Text(
            postData.postersName,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(postData.postersRole),
        ),
        Card(
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
        ),
      ],
    );
  }

  Widget iconButtons(PostData data) {
    String userToken = sharedPreferences.getString(SharedPreferencesKey.token);
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
