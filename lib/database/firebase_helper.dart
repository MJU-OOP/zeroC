import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_c/data/post_data.dart';

class DatabaseHelper {
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
          .orderBy('create_at', descending: true) // create_at 필드 기준으로 내림차순 정렬
          .get();

      return snapshot.docs.map((doc) => PostData.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error getting posts: $e");
      return [];
    }
  }

  // 학교 ID에 따라 게시물을 가져오는 메서드
  Future<List<PostData>> getPostsBySchool(String schoolName) async {
    try {
      // school_name을 사용하여 school_id 찾기
      QuerySnapshot schoolSnapshot = await _firestore
          .collection('School')
          .where('school_name', isEqualTo: schoolName)
          .get();

      if (schoolSnapshot.docs.isEmpty) {
        print('No school found with name: $schoolName');
        return [];
      }

      String schoolId = schoolSnapshot.docs.first.id;

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

  Future<Map<String, int>> getSchoolRankings() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Feed').get();
      Map<String, int> schoolPostCounts = {};

      for (var doc in snapshot.docs) {
        try {
          print("Document data: ${doc.data()}");
          String schoolId = doc['school_id'];
          print("Processing school_id: $schoolId");

          // School 컬렉션에서 school_id에 해당하는 문서 가져오기
          QuerySnapshot schoolQuery = await _firestore
              .collection('School')
              .where('school_id', isEqualTo: schoolId)
              .limit(1)
              .get();

          if (schoolQuery.docs.isNotEmpty) {
            String schoolName = schoolQuery.docs.first['school_name'] ?? schoolId;
            print("School name found: $schoolName for school_id: $schoolId");

            if (schoolPostCounts.containsKey(schoolName)) {
              schoolPostCounts[schoolName] = schoolPostCounts[schoolName]! + 1;
            } else {
              schoolPostCounts[schoolName] = 1;
            }
          } else {
            print('School document for $schoolId not found, using school_id');
            if (schoolPostCounts.containsKey(schoolId)) {
              schoolPostCounts[schoolId] = schoolPostCounts[schoolId]! + 1;
            } else {
              schoolPostCounts[schoolId] = 1;
            }
          }
        } catch (e) {
          print("Error accessing school information: $e");
        }
      }

      return schoolPostCounts;
    } catch (e) {
      print("Error getting school rankings: $e");
      return {};
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