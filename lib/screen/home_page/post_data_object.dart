import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String quote;
  int fileType; //1 text, 2 image
  int likesCount;
  int commentCount;
  String imageLink;

  PostData(String data, int fileType, int likesCount, int commentCount,
      String imageLink) {
    this.quote = data;
    this.fileType = fileType;
    this.likesCount = likesCount;
    this.commentCount = commentCount;
    this.imageLink = imageLink;
  }

  PostData.zero();

  PostData mapToObject(Map<String, dynamic> map) {
    return PostData(
      map["quote"],
      map["file_type"],
      map["likes_count"],
      map["comments_count"],
      map["image_link"],
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
