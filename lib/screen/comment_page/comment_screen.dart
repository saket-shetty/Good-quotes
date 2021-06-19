import 'package:flutter/material.dart';
import 'package:motivational_quotes/common_widgets/common_appbar_widget.dart';
import 'package:motivational_quotes/common_widgets/profile_image_widget.dart';
import 'package:motivational_quotes/screen/comment_page/comment_bloc.dart';
import 'package:motivational_quotes/screen/comment_page/comment_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_screen.dart';

class CommentScreen extends StatefulWidget {
  final int timestamp;
  final String postToken;
  const CommentScreen(
      {Key key, @required this.timestamp, @required this.postToken})
      : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentFieldController = TextEditingController();
  CommentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CommentBloc(widget.timestamp);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFfaf3f3),
      appBar: commonAppBar("Comments"),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _commentTileWidget(),
            ),
            _bottomTextField(),
          ],
        ),
      ),
    );
  }

  Widget _commentTileWidget() {
    return StreamBuilder<List<CommentDataObject>>(
      stream: _bloc.commentListStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<CommentDataObject> list = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: GestureDetector(
                    child: profileImageWidget(
                        profileImageUrl: list[index].imageUrl),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userToken: list[index].token),
                        ),
                      );
                    },
                  ),
                  title: Text(list[index].name),
                  subtitle: Text(list[index].comment),
                );
              },
              itemCount: list.length);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _bottomTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFf4eee8),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100.0,
        ),
        child: TextFormField(
          controller: _commentFieldController,
          textAlignVertical: TextAlignVertical.center,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Add a comment...",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: profileImageWidget(),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                await _bloc.postCommentInFireStore(_commentFieldController.text,
                    widget.timestamp, widget.postToken);
                _commentFieldController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }
}
