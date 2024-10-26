import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch posts with pagination
  Future<List<QueryDocumentSnapshot>> fetchPosts(
      {DocumentSnapshot? lastPost}) async {
    Query query = _firestore.collection('posts').orderBy('timestamp').limit(10);

    if (lastPost != null) {
      query = query.startAfterDocument(lastPost);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs;
  }
}
