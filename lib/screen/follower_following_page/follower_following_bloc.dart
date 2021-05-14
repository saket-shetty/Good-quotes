import 'dart:async';

import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:rxdart/subjects.dart';

class FollowerFollowingBloc {
  ProfileObject _profileObject = ProfileObject.zero();

  StreamController<List<ProfileObject>> _profileDetailstreamController =
      BehaviorSubject<List<ProfileObject>>();

  Stream<List<ProfileObject>> get profileDetailsStream =>
      _profileDetailstreamController.stream;

  StreamSink<List<ProfileObject>> get profileDetailsSink =>
      _profileDetailstreamController.sink;

  FollowerFollowingBloc(int tab, String token) {
    getConnectionData(tab, token);
  }

  getConnectionData(int tab, String token) {
    firebaseFirestore.collection("user").doc(token).snapshots().listen(
      (event) {
        profileDetailsSink.add(_profileObject.fromMapLimitedDataObject(
            event.data()[tab == 1 ? "follower" : "following"]));
      },
    );
  }

  dispose() {
    _profileDetailstreamController.close();
  }
}
