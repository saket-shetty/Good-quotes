import 'dart:async';

import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/message_page/message_object.dart';
import 'package:rxdart/subjects.dart';

class MessageBloc {
  MessageObject _messageObject = MessageObject.zero();

  String dataRefKey;

  StreamController<List<MessageObject>> _messageListController =
      BehaviorSubject<List<MessageObject>>();

  Stream<List<MessageObject>> get messageListStream =>
      _messageListController.stream;

  StreamSink<List<MessageObject>> get messageListSink =>
      _messageListController.sink;

  MessageBloc(String selfToken, String friendToken, {bool globalChat = false}) {
    if (globalChat) {
      getGlobalMessageData();
    } else {
      settingOrCreatingDocument(selfToken, friendToken);
    }
  }

  getMessageDataFromFireStore() {
    firebaseFirestore
        .collection("message")
        .doc(dataRefKey)
        .collection("timestamp")
        .snapshots()
        .listen((event) {
      messageListSink.add(_messageObject.fromArrayObject(event.docs));
    });
  }

  getGlobalMessageData() {
    firebaseFirestore.collection("global_chat").snapshots().listen((event) {
      messageListSink.add(_messageObject.fromArrayObject(event.docs));
    });
  }

  Future<void> sendMessageDataToFireStore(MessageObject messageObject) async {
    await firebaseFirestore
        .collection("message")
        .doc(dataRefKey)
        .collection("timestamp")
        .doc(messageObject.timestamp.toString())
        .set(messageObject.toMap());
  }

    Future<void> sendGlobalMessageDataToFireStore(MessageObject messageObject) async {
    await firebaseFirestore
        .collection("global_chat")
        .doc(messageObject.timestamp.toString())
        .set(messageObject.toMap());
  }

  settingOrCreatingDocument(String selfToken, String friendToken) async {
    generateUniqueKey(selfToken, friendToken);
    getMessageDataFromFireStore();
  }

  generateUniqueKey(String selfToken, String friendToken) {
    List<String> keys = <String>[selfToken, friendToken];
    keys.sort();
    this.dataRefKey = keys[0] + "-" + keys[1];
  }

  dispose() {
    _messageListController.close();
  }
}
