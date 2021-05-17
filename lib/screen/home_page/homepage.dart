import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomepageBloc _bloc;
  ScrollController _scrollController = ScrollController();
  TextEditingController _userNameSearchController = TextEditingController();
  String userName = sharedPreferences.getString(SharedPreferencesKey.name);
  String userToken = sharedPreferences.getString(SharedPreferencesKey.token);
  @override
  void initState() {
    super.initState();
    _bloc = HomepageBloc(userToken);
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
        bottomNavigationBar: bottomNavigationBar(context, 1, userToken,
            scrollController: _scrollController),
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
                            textPost(list[index], context),
                            iconButtons(list[index], userToken, _bloc, context),
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

  Widget userGreetingCard() {
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
                  color: Color(0xFF356B8F),
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
    return Center(
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
            Expanded(
              child: TextFormField(
                controller: _userNameSearchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "Search friend",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Icon(EvaIcons.search),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(0xFFfaf3f3),
                          ),
                        ),
                        onTapUp: (tapUpDetail) {
                          _showHoverWidget(tapUpDetail);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _userNameSearchController.clear();
                          userSearchDetailController.sink.add([]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showHoverWidget(TapUpDetails touchDetail) {
    _bloc.searchUserFromFirestore(_userNameSearchController.text);
    RelativeRect _buttonMenuPosition(BuildContext context, Offset _touchPos) {
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          _touchPos,
          _touchPos,
        ),
        Offset.zero & context.size,
      );
      return position;
    }

    showMenu<int>(
      context: context,
      position: _buttonMenuPosition(context, touchDetail.globalPosition),
      elevation: 1.0,
      useRootNavigator: false,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.5,
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            child: StreamBuilder<List<ProfileObject>>(
              stream: userSearchDetailController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  List<ProfileObject> list = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      ProfileObject user = list[index];
                      return ListTile(
                        leading: profileImageWidget(
                          profileImageUrl: user.imageUrl,
                        ),
                        title: Text(user.name),
                        subtitle: Text("member"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userToken: user.token,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: list.length,
                  );
                } else {
                  return Text("no users found");
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
