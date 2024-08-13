import 'package:flutter/material.dart';

import '../database/firebase_helper.dart';
import '../feed/certify_screen.dart';
import '../feed/feed_screen.dart';
import '../user/my_page_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MapEntry<String, int>> sortedSchoolRankings = [];
  bool isLoading = true;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadSchoolRankings();
  }

  Future<void> _loadSchoolRankings() async {
    final dbHelper = DatabaseHelper();
    Map<String, int> rankings = await dbHelper.getSchoolRankings();

    // rankings를 postCount 내림차순으로 정렬
    setState(() {
      sortedSchoolRankings = rankings.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      isLoading = false;
    });

    print("Sorted school rankings: $sortedSchoolRankings"); // 랭킹 데이터 출력
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이번주 챌린지: 텀블러 사용'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '순위',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedSchoolRankings.length,
              itemBuilder: (context, index) {
                String schoolName = sortedSchoolRankings[index].key;
                int postCount = sortedSchoolRankings[index].value;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedScreen(
                          schoolId: '', // schoolId로 schoolName을 전달
                          schoolImageUrl: '', // 필요에 따라 학교 이미지를 추가할 수 있습니다.
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1}위 $schoolName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '탄소 절약 게시글 수 : $postCount 개',
                          style: TextStyle(fontSize: 16),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (_currentIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CertifyScreen()),
            );
          } else if (_currentIndex == 1) {
            // 현재 화면이므로 아무 작업도 하지 않음
          } else if (_currentIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPageScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: '인증',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}