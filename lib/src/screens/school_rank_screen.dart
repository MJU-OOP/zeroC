import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/components/main_layout.dart';
import 'package:zeroC/src/screens/school_feed_screen.dart';

class SchoolRankScreen extends StatefulWidget {
  @override
  _SchoolRankScreenState createState() => _SchoolRankScreenState();
}

class _SchoolRankScreenState extends State<SchoolRankScreen> {
  Future<List<Map<String, dynamic>>> _getSchoolRanks() async {
    QuerySnapshot schoolsSnapshot = await FirebaseFirestore.instance.collection('School').get();
    List<Map<String, dynamic>> schoolRanks = [];

    for (var schoolDoc in schoolsSnapshot.docs) {
      String schoolId = schoolDoc.id;
      String schoolName = schoolDoc['school_name'];

      // 각 학교 ID에 해당하는 피드 개수 카운트
      QuerySnapshot feedSnapshot = await FirebaseFirestore.instance
          .collection('feeds')
          .where('school_id', isEqualTo: schoolId)
          .get();

      int feedCount = feedSnapshot.size;

      schoolRanks.add({
        'school_id': schoolId,
        'school_name': schoolName,
        'feed_count': feedCount,
      });
    }

    // feed_count를 기준으로 내림차순 정렬
    schoolRanks.sort((a, b) => b['feed_count'].compareTo(a['feed_count']));

    return schoolRanks;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getSchoolRanks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('데이터가 없습니다.'));
          }

          List<Map<String, dynamic>> schoolRanks = snapshot.data!;

          return ListView.builder(
            itemCount: schoolRanks.length,
            itemBuilder: (context, index) {
              var school = schoolRanks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchoolFeedScreen(
                        schoolId: school['school_id'],
                        schoolName: school['school_name'],
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}위 ${school['school_name']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${school['feed_count']}개의 피드',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}