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

  // 좋아요 업데이트 메서드
  Future<void> updateLike(PostData postData, String userId) async {
    DocumentReference postRef =
        _firestore.collection('Feed').doc(postData.feedId);

    DocumentSnapshot likeSnapshot =
        await postRef.collection('user_liked').doc(userId).get();

    if (likeSnapshot.exists) {
      // 이미 좋아요를 누른 경우, 좋아요를 취소
      await postRef.update({'like': FieldValue.increment(-1)});
      await postRef.collection('user_liked').doc(userId).delete();
    } else {
      // 좋아요를 누르지 않은 경우, 좋아요 추가
      await postRef.update({'like': FieldValue.increment(1)});
      await postRef
          .collection('user_liked')
          .doc(userId)
          .set({'liked_at': Timestamp.now()});
    }
  }

  // 사용자가 해당 게시물에 좋아요를 눌렀는지 확인하는 메서드
  Future<bool> checkIfLiked(PostData postData, String userId) async {
    DocumentSnapshot likeSnapshot = await _firestore
        .collection('Feed')
        .doc(postData.feedId)
        .collection('user_liked')
        .doc(userId)
        .get();

    return likeSnapshot.exists;
  }

  // 좋아요 순으로 피드를 가져오는 메서드
  Future<List<PostData>> getPostsSortedByLikes(String schoolId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Feed')
          .where('school_id', isEqualTo: schoolId)
          .orderBy('like', descending: true)
          .get();

      return snapshot.docs.map((doc) => PostData.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error getting posts by likes: $e");
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