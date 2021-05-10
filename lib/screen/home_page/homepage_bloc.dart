import 'dart:async';

import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';
import 'package:rxdart/rxdart.dart';

class HomepageBloc {
  PostData postData = PostData.zero();
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

  dispose() {
    postListController.close();
  }
}
