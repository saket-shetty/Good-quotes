import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_bloc.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/social_login/google_signin.dart';

class ProfileScreen extends StatefulWidget {
  final String userToken;
  const ProfileScreen({Key key, this.userToken}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String token = sharedPreferences.getString(SharedPreferencesKey.token);
  ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProfileBloc(widget.userToken ?? token);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf3f3),
      bottomNavigationBar: bottomNavigationBar(context, 4),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<ProfileObject>(
                stream: _bloc.profileDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    ProfileObject _profileObject = snapshot.data;
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 3.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF356B8F),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.menu,
                                    color: Color(0xFF356B8F),
                                  ),
                                  onTapUp: (tapUpDetails) {
                                    _showDialogOptions(tapUpDetails);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 20.0, left: 15.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFF356B8F),
                                fontFamily: "Opensans",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: profileImageWidget(
                              profileImageUrl: _profileObject.imageUrl,
                              width: 45),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _profileObject.name,
                              style: TextStyle(
                                fontSize: 23,
                                color: Color(0xFF356B8F),
                                fontFamily: "Opensans",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _profileObject.status ?? "Add Status",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF5E8FAD),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              activityMetrics(
                                  "Posts", _profileObject.postCounts ?? 0),
                              activityMetrics("Followers", 0),
                              activityMetrics("Follows", 0),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              StreamBuilder<List<PostData>>(
                stream: _bloc.postCreatedStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    List<PostData> list = snapshot.data;
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (_, index) => textPost(
                            list[index], context,
                            hideHeader: true, dynamicWidth: true),
                        itemCount: list.length,
                      ),
                    );
                  } else {
                    return Text("no post create");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget activityMetrics(String name, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5E8FAD),
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Opensans",
            color: Color(0xFF356B8F),
          ),
        ),
      ],
    );
  }

  _showDialogOptions(TapUpDetails touchDetail) {
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
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text("Logout"),
                  onTap: () async {
                    print("Logout clicked");
                    Navigator.pop(context);
                    SignInGoogle().handleGoogleSignOut(context);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                GestureDetector(
                  child: Text("Saved Post"),
                  onTap: () {
                    print("Logout clicked");
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                GestureDetector(
                  child: Text("Edit Profile"),
                  onTap: () {
                    print("Logout clicked");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
