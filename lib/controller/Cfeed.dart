import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_c/data/Mfeed.dart';

class FeedController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(PostData postData) async {
    try {
      await _firestore.collection('Feed').add(postData.toFirestore());
    } catch (e) {
      print("Error adding post: $e");
    }
  }

  Future<List<PostData>> getPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Feed')
          .orderBy('create_at', descending: true)
          .get();

      return snapshot.docs.map((doc) => PostData.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error getting posts: $e");
      return [];
    }
  }

  Future<List<PostData>> getPostsBySchool(String schoolId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Feed')
          .where('school_id', isEqualTo: schoolId)
          .orderBy('create_at', descending: true)
          .get();

      return snapshot.docs.map((doc) => PostData.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error getting posts by school: $e");
      return [];
    }
  }
  
  Future<void> updatePost(String id, PostData postData) async {
    try {
      await _firestore.collection('Feed').doc(id).update(postData.toFirestore());
    } catch (e) {
      print("Error updating post: $e");
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _firestore.collection('Feed').doc(id).delete();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }
}
