import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:zero_c/data/Mfeed.dart';

class FeedController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImageToStorage(Uint8List image, String path) async {
    try {
      // 경로 생성
      Reference storageReference = _storage.ref().child(path);
      UploadTask uploadTask = storageReference.putData(image);
      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> addPost(PostData postData, Uint8List? feedImage) async {
    try {
      String? imageUrl;

      if (feedImage != null) {
        String imagePath =
            'feed/${postData.userId}/${basename(DateTime.now().toString())}.jpg';
        imageUrl = await uploadImageToStorage(feedImage, imagePath);
      }

      postData = postData.copyWith(feedImage: imageUrl);

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
      await _firestore
          .collection('Feed')
          .doc(id)
          .update(postData.toFirestore());
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
