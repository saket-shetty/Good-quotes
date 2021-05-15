import 'package:cloud_firestore/cloud_firestore.dart';

class MessageObject {
  String message;
  int timestamp;
  String token;

  MessageObject.zero();

  MessageObject(this.message, this.timestamp, this.token);

  Map<String, dynamic> toMap() {
    return {
      "message": this.message,
      "timestamp": this.timestamp,
      "token": this.token,
    };
  }

  MessageObject fromMapObject(Map<String, dynamic> map) {
    return MessageObject(
      map["message"],
      map["timestamp"],
      map["token"],
    );
  }

  List<MessageObject> fromArrayObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotList) {
    List<MessageObject> list = [];
    if (snapshotList != null) {
      for (var object in snapshotList) {
        list.add(fromMapObject(object.data()));
      }
    }
    return list;
  }
}
