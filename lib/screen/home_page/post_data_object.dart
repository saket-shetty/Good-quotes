import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String quote;
  int fileType; //1 text, 2 image
  int likesCount;
  int commentCount;
  String imageLink;
  int timestamp;
  List likes;
  String backgroundColor;
  int fontSize;
  PostData(
      String data,
      int fileType,
      int likesCount,
      int commentCount,
      String imageLink,
      int timestamp,
      List likes,
      String backgroundColor,
      int fontSize) {
    this.quote = data;
    this.fileType = fileType;
    this.likesCount = likesCount;
    this.commentCount = commentCount;
    this.imageLink = imageLink;
    this.timestamp = timestamp;
    this.likes = likes;
    this.backgroundColor = backgroundColor;
    this.fontSize = fontSize;
  }

  PostData.zero();

  PostData mapToObject(Map<String, dynamic> map) {
    return PostData(
      map["quote"],
      map["file_type"],
      map["likes_count"],
      map["comments_count"],
      map["image_link"],
      map["timestamp"],
      map["likes"],
      map["background_color"],
      map["font_size"],
    );
  }

  List<PostData> forArrayToObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    List<PostData> postListData = [];
    for (var object in data) {
      postListData.add(mapToObject(object.data()));
    }
    return postListData;
  }
}
