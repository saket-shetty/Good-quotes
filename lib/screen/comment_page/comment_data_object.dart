import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataObject {
  String name;
  String comment;
  String imageUrl;
  String token;
  String postToken;

  CommentDataObject.zero();
  CommentDataObject(this.name, this.comment, this.imageUrl, this.token, this.postToken);

  CommentDataObject fromMap(Map<String, dynamic> map) {
    return CommentDataObject(
      map["name"],
      map["comment"],
      map["image"],
      map["token"],
      map["postToken"]
    );
  }

  toMap() {
    Map<String, String> map = {
      "name": this.name,
      "comment": this.comment,
      "image": this.imageUrl,
      "token": this.token,
      "postToken": this.postToken,
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
