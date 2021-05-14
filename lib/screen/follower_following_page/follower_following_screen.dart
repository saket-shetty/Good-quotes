import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/follower_following_page/follower_following_bloc.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_screen.dart';

class FollowerFollowingScreen extends StatefulWidget {
  final int tab;
  final String token;
  const FollowerFollowingScreen({Key key, @required this.tab, @required this.token})
      : super(key: key);
  @override
  _FollowerFollowingScreenState createState() =>
      _FollowerFollowingScreenState();
}

class _FollowerFollowingScreenState extends State<FollowerFollowingScreen> {
  FollowerFollowingBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = FollowerFollowingBloc(widget.tab, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(widget.tab == 1 ? "Follower" : "Following"),
      body: StreamBuilder<List<ProfileObject>>(
        stream: _bloc.profileDetailsStream,
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
    );
  }
}
