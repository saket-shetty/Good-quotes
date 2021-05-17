import 'dart:async';

import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/message_page/chat_listing_page/chat_listing_object.dart';
import 'package:motivational_quotes/screen/profile_page/profile_object.dart';
import 'package:rxdart/subjects.dart';

class ChatListingBloc {
  StreamController<List<ChatListingObject>> chatListingObject =
      BehaviorSubject<List<ChatListingObject>>();
  ChatListingBloc(String token) {
    getChatList(token);
  }
  ProfileObject profileObject = ProfileObject.zero();

  getChatList(String token) {
    firebaseFirestore.collection("message").snapshots().listen((value) async {
      List<ChatData> x = value.docs.map((e) {
        if (e.id.contains(token)) {
          String friendToken = e.id.replaceAll("-", "").replaceAll(token, "");
          return ChatData(
              friendToken, e.data()["message"], e.data()["timestamp"]);
        }
      }).toList();
      List<ChatListingObject> xx = await getProfileDetailFromFirestore(x);
      chatListingObject.sink.add(xx);
    });
  }

  Future<List<ChatListingObject>> getProfileDetailFromFirestore(
      List<ChatData> chatDataList) async {
    List<ChatListingObject> list = [];
    for (ChatData chatData in chatDataList) {
      if (chatData != null && chatData.token != null) {
        var x = await firebaseFirestore
            .collection("user")
            .doc(chatData.token)
            .get();
        list.add(ChatListingObject(profileObject.fromMapObject(x.data()),
            chatData.message, chatData.timestamp));
      }
    }
    list.sort((obj1, obj2) => obj2.timestamp - obj1.timestamp);
    return list;
  }

  dispose() {
    chatListingObject.close();
  }
}

class ChatData {
  String token;
  String message;
  int timestamp;
  ChatData(this.token, this.message, this.timestamp);
}
