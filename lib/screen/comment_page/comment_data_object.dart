import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataObject {
  String name;
  String comment;
  String imageUrl;
  String token;

  CommentDataObject.zero();
  CommentDataObject(this.name, this.comment, this.imageUrl, this.token);

  CommentDataObject fromMap(Map<String, dynamic> map) {
    return CommentDataObject(
      map["name"],
      map["comment"],
      map["image"],
      map["token"],
    );
  }

  toMap() {
    Map<String, String> map = {
      "name": this.name,
      "comment": this.comment,
      "image": this.imageUrl,
      "token": this.token,
    };
    return map;
  }

  List<CommentDataObject> fromMapArrayToList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> commentSnapshotList) {
    List<CommentDataObject> list = [];
    for (var commentSnapshot in commentSnapshotList) {
      list.add(fromMap(commentSnapshot.data()));
    }
    return list;
  }
}
