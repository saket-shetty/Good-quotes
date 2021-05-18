import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/post_detail_page/post_detail_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  final String token;
  final String timestamp;
  const PostDetailScreen(
      {Key key, @required this.token, @required this.timestamp})
      : super(key: key);
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostDetailBloc _bloc;
  HomepageBloc _homepageBloc;
  @override
  void initState() {
    super.initState();
    _bloc = PostDetailBloc(widget.timestamp);
    _homepageBloc = HomepageBloc(widget.token, isPostDetailPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar("Post"),
      bottomNavigationBar: bottomNavigationBar(context, 4, widget.token),
      body: StreamBuilder<PostData>(
        stream: _bloc.postDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PostData _data = snapshot.data;
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textPost(_data, context),
                  iconButtons(_data, widget.token, _homepageBloc, context),
                  socialDataMetrics(_data, context),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
