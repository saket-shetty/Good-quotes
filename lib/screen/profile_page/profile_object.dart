import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileObject {
  String name;
  String token;
  String imageUrl;
  int postCounts;
  String status;

  ProfileObject.zero();

  ProfileObject(
    this.name,
    this.token,
    this.imageUrl,
    this.postCounts,
    this.status,
  );

  Map<String, dynamic> toMapLimitedData() {
    return {
      "user_name": this.name,
      "token": this.token,
      "image_url": this.imageUrl,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "user_name": this.name,
      "token": this.token,
      "image_url": this.imageUrl,
      "posts_count": this.postCounts,
      "status": this.status,
    };
  }

  ProfileObject fromMapObject(Map<String, dynamic> map) {
    return ProfileObject(
      map["user_name"],
      map["token"],
      map["image_url"],
      map["posts_count"],
      map["status"],
    );
  }

  List<ProfileObject> fromArrayObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
      {String name}) {
    List<ProfileObject> list = [];
    for (var object in data) {
      if (name != null) {
        if (name != "" &&
            object
                .data()["user_name"]
                .toString()
                .toLowerCase()
                .contains(name)) {
          list.add(fromMapObject(object.data()));
        }
      } else {
        list.add(fromMapObject(object.data()));
      }
    }
    return list;
  }
}
