import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/constants/shared_preferences_key.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/comment_page/comment_data_object.dart';
import 'package:rxdart/subjects.dart';

class CommentBloc {
  CommentDataObject _commentDataObject = CommentDataObject.zero();
  StreamController<List<CommentDataObject>> _commentListController =
      BehaviorSubject<List<CommentDataObject>>();

  Stream<List<CommentDataObject>> get commentListStream =>
      _commentListController.stream;

  StreamSink<List<CommentDataObject>> get commentListSink =>
      _commentListController.sink;

  CommentBloc(int timestamp) {
    getDataFromFirestoreDB(timestamp);
  }

  getDataFromFirestoreDB(int timestamp) {
    firebaseFirestore
        .collection("post")
        .doc(timestamp.toString())
        .collection("comments")
        .snapshots()
        .listen((event) {
      commentListSink.add(_commentDataObject.fromMapArrayToList(event.docs));
    });
  }

  Future<void> postCommentInFireStore(String comment, int postTimestamp) async {
    String name = sharedPreferences.getString(SharedPreferencesKey.name);
    String image = sharedPreferences.getString(SharedPreferencesKey.image);
    String token = sharedPreferences.getString(SharedPreferencesKey.token);
    int timestamp = Timestamp.now().millisecondsSinceEpoch;
    await firebaseFirestore
        .collection("post")
        .doc(postTimestamp.toString())
        .collection("comments")
        .doc(timestamp.toString())
        .set(CommentDataObject(name, comment, image, token).toMap());

    firebaseFirestore.collection("post").doc(postTimestamp.toString()).update({
      "comments_count": FieldValue.increment(1),
    });
  }

  dispose() {
    _commentListController.close();
  }
}
