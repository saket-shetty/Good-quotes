import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class ProfileObject {
  String name;
  String token;
  String imageUrl;
  int likeCounts;
  int postCounts;
  String status;
  List<PostData> postList;

  ProfileObject.zero();
  PostData postData = PostData.zero();

  ProfileObject(
    this.name,
    this.token,
    this.imageUrl,
    this.likeCounts,
    this.postCounts,
    this.status,
    this.postList,
  );

  ProfileObject fromMapObject(Map<String, dynamic> map) {
    return ProfileObject(
      map["user_name"],
      map["token"],
      map["image_url"],
      map["likes_count"],
      map["posts_count"],
      map["status"],
      // postData.forArrayToObject(map["post_data"]),
      map["post_data"],
    );
  }

  List<ProfileObject> fromArrayObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
      {String name}) {
    List<ProfileObject> list = [];
    for (var object in data) {
      if (name != null) {
        if (name != "" &&
            object.data()["user_name"].toString().contains(name)) {
          list.add(fromMapObject(object.data()));
        }
      } else {
        list.add(fromMapObject(object.data()));
      }
    }
    return list;
  }
}
