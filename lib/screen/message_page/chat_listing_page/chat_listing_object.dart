import 'package:motivational_quotes/screen/profile_page/profile_object.dart';

class ChatListingObject {
  ProfileObject friendProfile;
  String message;
  int timestamp;

  ChatListingObject(this.friendProfile, this.message, this.timestamp);
}
