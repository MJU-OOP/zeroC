import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_c/data/Mschool.dart';

class SchoolController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 특정 School 데이터를 가져오기 (schoolId로)
  Future<SchoolData?> getSchoolById(String schoolId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('School')
          .where('school_id', isEqualTo: schoolId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return SchoolData.fromFirestore(doc);
      } else {
        print("School with id $schoolId not found");
        return null;
      }
    } catch (e) {
      print("Error getting school by id: $e");
      return null;
    }
  }


    // School 데이터 추가
  // Future<void> addSchool(SchoolData schoolData) async {
  //   try {
  //     await _firestore.collection('School').add(schoolData.toFirestore());
  //   } catch (e) {
  //     print("Error adding school: $e");
  //   }
  // }

  // // 특정 School 데이터 업데이트
  // Future<void> updateSchool(String schoolId, SchoolData schoolData) async {
  //   try {
  //     await _firestore.collection('School').doc(schoolId).update(schoolData.toFirestore());
  //   } catch (e) {
  //     print("Error updating school: $e");
  //   }
  // }

  // // 특정 School 데이터 삭제
  // Future<void> deleteSchool(String schoolId) async {
  //   try {
  //     await _firestore.collection('School').doc(schoolId).delete();
  //   } catch (e) {
  //     print("Error deleting school: $e");
  //   }
  // }
}
