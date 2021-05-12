import 'package:motivational_quotes/main.dart';
import 'package:motivational_quotes/screen/home_page/post_data_object.dart';

class AddPostRepository {
  Future<void> postDataToFireStore(PostData data) async {
    await firebaseFirestore
        .collection("post")
        .doc(data.timestamp.toString())
        .set(data.toMap());
  }
}
