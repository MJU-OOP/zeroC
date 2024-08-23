import 'package:flutter/material.dart';
import 'package:zero_c/controller/Crank.dart'; // RankController import
import 'package:zero_c/feed/certify_screen.dart';
import 'package:zero_c/feed/feed_screen.dart';
import 'package:zero_c/user/my_page_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RankController _rankController = RankController(); // RankController 인스턴스 생성
  int _currentIndex = 1;

  Future<List<Map<String, dynamic>>> _loadSchoolRankings() async {
    return await _rankController.getSchoolRankings(); // List<Map<String, dynamic>> 타입 반환
  }

  void _navigateToPage(int index) {
    if (_currentIndex == index) return;

    Widget nextPage;

    if (index == 0) {
      nextPage = CertifyScreen();
    } else if (index == 1) {
      return; // 홈 화면이므로 아무 작업도 하지 않음
    } else if (index == 2) {
      nextPage = MyPageScreen();
    } else {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '이번주 챌린지: 텀블러 사용',
          style: TextStyle(
            fontSize: 20, // 텍스트 크기
            fontWeight: FontWeight.bold, // 텍스트 굵기
            color: Colors.white, // 텍스트 색상
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black45,
                offset: Offset(1.0, 1.0),
              ),
            ], // 텍스트에 그림자 효과 추가
          ),
        ),
        centerTitle: true, // 타이틀 텍스트 중앙 배치
        backgroundColor: Color(0xFF4FC3B7), // 메인 컬러 설정
        elevation: 4.0, // 앱 바의 그림자 깊이 설정
        shadowColor: Colors.black45, // 그림자 색상 설정
      ),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned(
            bottom: 50, // 하단에서의 거리
            left: 0, // 좌측에서의 거리
            right: 0, // 우측에서의 거리
            child: Center(
              child: Container(
                width: 300,  // 원하는 너비
                height: 100, // 원하는 높이
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/logo.png'), // 로고 이미지 경로
                    fit: BoxFit.cover, // 이미지가 전체 배경에 맞게 조정됩니다.
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.3), // 이미지에 약간의 투명도를 적용
                      BlendMode.dstATop,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 콘텐츠 영역
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadSchoolRankings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF4FC3B7))); // 메인 색상
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                      "데이터를 불러오는 중 오류가 발생했습니다.",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                      "게시글이 없습니다.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ));
              } else {
                List<Map<String, dynamic>> sortedSchoolRankings = snapshot.data!;
                sortedSchoolRankings.sort(
                        (a, b) => b['postCount'].compareTo(a['postCount']));

                return ListView.builder(
                  itemCount: sortedSchoolRankings.length,
                  itemBuilder: (context, index) {
                    String schoolName = sortedSchoolRankings[index]['schoolName'];
                    int postCount = sortedSchoolRankings[index]['postCount'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF4FC3B7), // 메인 색상
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          title: Text(
                            schoolName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4FC3B7)), // 메인 색상
                          ),
                          subtitle: Text(
                            '탄소 절약 게시글 수 : $postCount 개',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedScreen(
                                  schoolId: sortedSchoolRankings[index]['schoolId'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToPage,
        selectedItemColor: Color(0xFF4FC3B7), // 선택된 아이템 색상 설정
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상 설정
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_square),
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