import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero_c/controller/Cschool.dart';
import 'package:zero_c/data/Mschool.dart';

class RankController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SchoolController _schoolController = SchoolController();

  Future<List<Map<String, dynamic>>> getSchoolRankings() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Feed').get();
      Map<String, Map<String, dynamic>> schoolPostCounts = {};

      for (var doc in snapshot.docs) {
        try {
          String schoolId = doc['school_id'];
          SchoolData? schoolData = await _schoolController.getSchoolById(schoolId);

          if (schoolData != null) {
            if (schoolPostCounts.containsKey(schoolId)) {
              schoolPostCounts[schoolId]!['postCount']++;
            } else {
              schoolPostCounts[schoolId] = {
                'schoolName': schoolData.schoolName,
                'postCount': 1
              };
            }
          } else {
            print('School with id $schoolId not found');
          }
        } catch (e) {
          print("School DB 접속 에러: $e");
        }
      }

      // Map을 List로 변환하여 반환
      return schoolPostCounts.entries.map((entry) {
        return {
          'schoolId': entry.key,
          'schoolName': entry.value['schoolName'],
          'postCount': entry.value['postCount']
        };
      }).toList();
    } catch (e) {
      print("DB 오류로 랭킹을 불러오지 못 했습니다: $e");
      return [];
    }
  }
}