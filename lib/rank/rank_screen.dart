import 'package:flutter/material.dart';
import 'package:zero_c/controller/Crank.dart';
import 'package:zero_c/feed/feed_screen.dart';

class RankScreen extends StatefulWidget {
  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  List<Map<String, dynamic>> sortedSchoolRankings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchoolRankings();
  }

  Future<void> _loadSchoolRankings() async {
    try {
      final rankController = RankController();
      List<Map<String, dynamic>> rankings = await rankController.getSchoolRankings();

      // 내림차순으로 정렬
      rankings.sort((a, b) => b['postCount'].compareTo(a['postCount']));

      setState(() {
        sortedSchoolRankings = rankings;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading school rankings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '이번주 챌린지: 텀블러 사용',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4FC3B7),
        elevation: 4.0,
        shadowColor: Colors.black45,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4FC3B7),
        ),
      )
          : Column(
        children: [
          Container(
            color: Color(0xFF4FC3B7),
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '순위',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedSchoolRankings.length,
              itemBuilder: (context, index) {
                String schoolName = sortedSchoolRankings[index]['schoolName'];
                int postCount = sortedSchoolRankings[index]['postCount'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedScreen(
                          schoolId: sortedSchoolRankings[index]['schoolId'],  // schoolId 전달
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1}위 $schoolName',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4FC3B7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '탄소 절약 게시글 수: $postCount 개',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}