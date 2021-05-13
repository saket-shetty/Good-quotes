import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/add_post/add_post_screen.dart';
import 'package:motivational_quotes/screen/home_page/homepage.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_screen.dart';

PreferredSizeWidget commonAppBar(String title) {
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
  );
}

Widget bottomNavigationBar(BuildContext context, int tab,
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
        InkWell(
          child: profileImageWidget(width: 14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
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
