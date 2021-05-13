import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class AddPostRepository {
  Future<void> postDataToFireStore(PostData data) async {
    await firebaseFirestore
        .collection("post")
        .doc(data.timestamp.toString())
        .set(data.toMap());

    await firebaseFirestore
        .collection("user")
        .doc(data.postersId)
        .update({"posts_count": FieldValue.increment(1)});
  }
}
