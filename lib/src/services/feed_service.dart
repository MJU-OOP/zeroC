import 'package:cloud_firestore/cloud_firestore.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 특정 school_id에 해당하는 피드 가져오기
  Stream<QuerySnapshot> getPostsBySchool(String schoolId) {
    return _firestore
        .collection('feeds')
        .where('school_id', isEqualTo: schoolId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // 새로운 피드 생성
  Future<void> createPost({
    required String userId,
    required String nickname,
    required String schoolId,
    String? imageUrl,
    required String content,
  }) async {
    try {
      String feedId = _firestore.collection('feeds').doc().id;

      await _firestore.collection('feeds').doc(feedId).set({
        'feed_id': feedId,
        'user_id': userId,
        'nickname': nickname,
        'school_id': schoolId,
        'image_url': imageUrl,
        'content': content,
        'created_at': Timestamp.now(),
      });
    } catch (e) {
      print("Error creating post: $e");
    }
  }
}