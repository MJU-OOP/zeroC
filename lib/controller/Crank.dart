import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_c/controller/Cschool.dart';
import 'package:zero_c/data/Mschool.dart';

class RankController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SchoolController _schoolController = SchoolController();

  Future<Map<String, int>> getSchoolRankings() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Feed').get();
      Map<String, int> schoolPostCounts = {};

      for (var doc in snapshot.docs) {
        try {
          String schoolId = doc['school_id'];

          // School 데이터를 가져옴
          SchoolData? schoolData = await _schoolController.getSchoolById(schoolId);

          if (schoolData != null) {
            String schoolName = schoolData.schoolName;

            if (schoolPostCounts.containsKey(schoolName)) {
              schoolPostCounts[schoolName] = schoolPostCounts[schoolName]! + 1;
            } else {
              schoolPostCounts[schoolName] = 1;
            }
          } else {
            print('School with id $schoolId not found');
            if (schoolPostCounts.containsKey(schoolId)) {
              schoolPostCounts[schoolId] = schoolPostCounts[schoolId]! + 1;
            } else {
              schoolPostCounts[schoolId] = 1;
            }
          }
        } catch (e) {
          print("School DB 접속 에러: $e");
        }
      }

      return schoolPostCounts;
    } catch (e) {
      print("DB 오류로 랭킹을 불러오지 못 했습니다: $e");
      return {};
    }
  }
}
