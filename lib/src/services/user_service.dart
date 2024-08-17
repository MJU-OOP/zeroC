import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      // 현재 로그인된 사용자 ID 가져오기
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Firestore에서 user_table 컬렉션의 문서 가져오기
      DocumentSnapshot userDoc = await _firestore.collection('user_table').doc(userId).get();

      if (userDoc.exists) {
        // 문서가 존재하면 데이터 반환
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // 문서가 없으면 null 반환
        return null;
      }
    } catch (e) {
      print("Error getting user info: $e");
      return null;
    }
  }
}