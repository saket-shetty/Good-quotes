import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  PostData postData = PostData.zero();
  ProfileObject profileObject = ProfileObject.zero();

  StreamController<List<PostData>> _postCreatedController =
      BehaviorSubject<List<PostData>>();

  Stream<List<PostData>> get postCreatedStream => _postCreatedController.stream;
  StreamSink<List<PostData>> get postCreatedSink => _postCreatedController.sink;

  StreamController<ProfileObject> _profileObjectController =
      BehaviorSubject<ProfileObject>();

  Stream<ProfileObject> get profileDataStream =>
      _profileObjectController.stream;
  StreamSink<ProfileObject> get profileDataSink =>
      _profileObjectController.sink;

  ProfileBloc(String token, {bool getAllPostData = true}) {
    getProfileDetailFromFirestore(token);
    getUserPostData(token);
  }

  getUserPostData(String token) {
    firebaseFirestore
        .collection("post")
        .where("posters_id", isEqualTo: token)
        .get()
        .then((value) {
      postCreatedSink
          .add(postData.forArrayToObject(value.docs).reversed.toList());
    });
  }

  getProfileDetailFromFirestore(String token) {
    firebaseFirestore.collection("user").doc(token).snapshots().listen((value) {
      profileDataSink.add(profileObject.fromMapObject(value.data()));
    });
  }

  Future<void> followOrUnFollowUser(String selfToken, String friendToken,
      ProfileObject self, ProfileObject friend, bool isUserFollowing) async {
    await firebaseFirestore.collection("user").doc(selfToken).update({
      "following": isUserFollowing
          ? FieldValue.arrayRemove([friend.toMapLimitedData()])
          : FieldValue.arrayUnion([friend.toMapLimitedData()]),
    });
    await firebaseFirestore.collection("user").doc(friendToken).update({
      "follower": isUserFollowing
          ? FieldValue.arrayRemove([self.toMapLimitedData()])
          : FieldValue.arrayUnion([self.toMapLimitedData()]),
    });
  }

  dispose() {
    _postCreatedController.close();
    _profileObjectController.close();
  }
}
