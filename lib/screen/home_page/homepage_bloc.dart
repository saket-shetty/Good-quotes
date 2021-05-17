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

  StreamController<List<PostData>> postListSavedController =
      BehaviorSubject<List<PostData>>();

  Stream<List<PostData>> get postListSavedStream => postListController.stream;
  StreamSink<List<PostData>> get postListSavedSink => postListController.sink;

  StreamController<List<PostData>> explorePostListController =
      BehaviorSubject<List<PostData>>();

  Stream<List<PostData>> get explorePostListStream => postListController.stream;
  StreamSink<List<PostData>> get explorePostListSink => postListController.sink;

  HomepageBloc.savedPost(String token) {
    getSavedPostData(token);
  }

  HomepageBloc(String token, {bool isExplorePage = false}) {
    if (!isExplorePage) {
      getDataFromFireStore(token);
    } else {
      getPostDataForExplorePage();
    }
  }

  getDataFromFireStore(String _token) async {
    firebaseFirestore
        .collection("user")
        .doc(_token)
        .snapshots()
        .listen((value) {
      List<String> following = [_token];
      ProfileObject _profileData = ProfileObject.zero();
      following.addAll(_profileData.fromMapObject(value.data()).followingKeys);
      if (following.length > 0) {
        firebaseFirestore.collection("post").snapshots().listen((event) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> listQuerySnapshot =
              [];
          for (var q in event.docs) {
            if (following.contains(q.data()["posters_id"])) {
              listQuerySnapshot.add(q);
            }
          }
          postListSink.add(postData.forArrayToObject(listQuerySnapshot));
        });
      }
    });
  }

  getPostDataForExplorePage() {
    firebaseFirestore.collection("post").snapshots().listen((event) {
      explorePostListSink.add(postData.forArrayToObject(event.docs));
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

  getSavedPostData(String token) {
    firebaseFirestore
        .collection("post")
        .where("post_saved", arrayContains: token)
        .snapshots()
        .listen((value) {
      postListSavedSink.add(postData.forArrayToObject(value.docs));
    });
  }

  dispose() {
    postListController.close();
    postListSavedController.close();
    explorePostListController.close();
  }
}
