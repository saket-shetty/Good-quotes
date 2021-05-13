import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:rxdart/rxdart.dart';

class HomepageBloc {
  PostData postData = PostData.zero();
  ProfileObject profileObject = ProfileObject.zero();
  StreamController<List<PostData>> postListController =
      BehaviorSubject<List<PostData>>();

  Stream<List<PostData>> get postListStream => postListController.stream;
  StreamSink<List<PostData>> get postListSink => postListController.sink;

  HomepageBloc() {
    getDataFromFireStore();
  }

  getDataFromFireStore() async {
    firebaseFirestore.collection("post").snapshots().listen((event) {
      postListSink.add(postData.forArrayToObject(event.docs));
    });
  }

  likePost(int timestamp, String token, bool isLiked) async {
    firebaseFirestore.collection("post").doc(timestamp.toString()).update({
      "likes": !isLiked
          ? FieldValue.arrayUnion([token])
          : FieldValue.arrayRemove([token])
    });
  }

  savePost(int timestamp, String token, bool isSaved) async {
    firebaseFirestore.collection("post").doc(timestamp.toString()).update(
      {
        "post_saved": !isSaved
            ? FieldValue.arrayUnion([token])
            : FieldValue.arrayRemove([token])
      },
    );
  }

  searchUserFromFirestore(String userName) {
    firebaseFirestore.collection("user").get().then((value) {
      userSearchDetailController.sink
          .add(profileObject.fromArrayObject(value.docs, name: userName));
    });
  }

  dispose() {
    postListController.close();
  }
}
