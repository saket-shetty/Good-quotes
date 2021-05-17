import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/homepage_bloc.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String token = sharedPreferences.getString(SharedPreferencesKey.token);
  HomepageBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = HomepageBloc(token, isExplorePage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar("Explore"),
      bottomNavigationBar: bottomNavigationBar(context, 2, token),
      body: StreamBuilder<List<PostData>>(
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
                      iconButtons(list[index], token, _bloc, context),
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
}
