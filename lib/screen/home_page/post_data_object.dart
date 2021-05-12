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
  String postersName;
  String postersId;
  String postersImageUrl;
  String postersRole;
  List postSavedByUsers;

  PostData(
      String quote,
      int fileType,
      int likesCount,
      int commentCount,
      String imageLink,
      int timestamp,
      List likes,
      String backgroundColor,
      int fontSize,
      String postersName,
      String postersId,
      String postersImageUrl,
      String postersRole,
      List postSavedByUsers) {
    this.quote = quote;
    this.fileType = fileType;
    this.likesCount = likesCount;
    this.commentCount = commentCount;
    this.imageLink = imageLink;
    this.timestamp = timestamp;
    this.likes = likes;
    this.backgroundColor = backgroundColor;
    this.fontSize = fontSize;
    this.postersName = postersName;
    this.postersId = postersId;
    this.postersImageUrl = postersImageUrl;
    this.postersRole = postersRole;
    this.postSavedByUsers = postSavedByUsers;
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
        map["posters_name"],
        map["posters_id"],
        map["posters_image_url"],
        map["posters_role"],
        map["post_saved"]);
  }

  List<PostData> forArrayToObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    List<PostData> postListData = [];
    for (var object in data) {
      postListData.add(mapToObject(object.data()));
    }
    return postListData;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "quote": this.quote,
      "file_type": this.fileType,
      "likes_count": this.likesCount,
      "comments_count": this.commentCount,
      "image_link": this.imageLink,
      "timestamp": this.timestamp,
      "likes": this.likes,
      "background_color": this.backgroundColor,
      "font_size": this.fontSize,
      "posters_name": this.postersName,
      "posters_id": this.postersId,
      "posters_image_url": this.postersImageUrl,
      "posters_role": this.postersRole,
      "post_saved": this.postSavedByUsers,
    };
    return map;
  }
}
