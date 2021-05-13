import 'dart:async';

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

  ProfileBloc(String token) {
    getUserPostData(token);
    getProfileDetailFromFirestore(token);
  }

  getUserPostData(String token) {
    firebaseFirestore
        .collection("post")
        .where("posters_id", isEqualTo: token)
        .get()
        .then((value) {
      List<PostData> list =
          postData.forArrayToObject(value.docs).reversed.toList();
      postCreatedSink.add(list);
    });
  }

  getProfileDetailFromFirestore(String token) {
    firebaseFirestore.collection("user").doc(token).get().then((value) {
      profileDataSink.add(profileObject.fromMapObject(value.data()));
    });
  }

  getSavedPostData(String token) {
    firebaseFirestore
        .collection("post")
        .where("post_saved", arrayContains: token)
        .get()
        .then((value) {
      List<PostData> list = postData.forArrayToObject(value.docs);
      print(list);
    });
  }

  dispose() {
    _postCreatedController.close();
    _profileObjectController.close();
  }
}
