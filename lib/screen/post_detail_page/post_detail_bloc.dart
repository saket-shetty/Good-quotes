import 'dart:async';

import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:rxdart/subjects.dart';

class PostDetailBloc {
  PostData _postData = PostData.zero();
  StreamController<PostData> _postDataController = BehaviorSubject<PostData>();
  Stream<PostData> get postDataStream => _postDataController.stream;
  StreamSink<PostData> get postDataSink => _postDataController.sink;
  PostDetailBloc(String timestamp) {
    getPostDetailFromFirestore(timestamp);
  }
  getPostDetailFromFirestore(String timestamp) {
    firebaseFirestore
        .collection("post")
        .doc(timestamp)
        .snapshots()
        .listen((event) {
      postDataSink.add(_postData.mapToObject(event.data()));
    });
  }

  dispose() {
    _postDataController.close();
  }
}
