import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../feed/certify_screen.dart';
import '../rank/home_screen.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String userName = '';
  String userEmail = '';
  String schoolName = '';
  int _currentIndex = 2; // 현재 페이지는 마이페이지이므로 2로 설정

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Firestore 인스턴스 가져오기
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Firestore에서 사용자 정보 가져오기 (documentId는 사용자 고유 ID로 대체 필요)
      DocumentSnapshot userSnapshot = await firestore.collection('Users').doc('hZw3fEc0doUnIp0xwY0x').get();

      // 사용자 데이터 존재 확인
      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot['name'];
          userEmail = userSnapshot['email'];

          // 학교 정보 가져오기
          String schoolId = userSnapshot['school_id'];
          _loadSchoolData(schoolId);
        });
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadSchoolData(String schoolId) async {
    try {
      // Firestore에서 학교 정보 가져오기
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot schoolSnapshot = await firestore.collection('School')
          .where('school_id', isEqualTo: schoolId)
          .get();

      if (schoolSnapshot.docs.isNotEmpty) {
        setState(() {
          schoolName = schoolSnapshot.docs.first['school_name'];
        });
      } else {
        print("School document does not exist");
      }
    } catch (e) {
      print('Error loading school data: $e');
    }
  }

  void _navigateToPage(int index) {
    if (_currentIndex == index) return; // 현재 페이지와 같은 경우 네비게이션 생략

    Widget nextPage;

    if (index == 0) {
      // 인증 페이지로 이동
      nextPage = CertifyScreen();
    } else if (index == 1) {
      // 홈 화면으로 이동
      nextPage = HomeScreen();
    } else {
      // 다른 페이지가 아니므로 현재 페이지 유지
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
          '마이 페이지',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF4FC3B7),
        elevation: 0, // 그림자 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5V9zbYT1VgsJYv3T14VI0irKZmrczFwpCpg&s'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : 'Test',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4FC3B7),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail.isNotEmpty ? userEmail : 'Test',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      schoolName.isNotEmpty ? schoolName : 'Test',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4FC3B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        '프로필 수정',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.account_circle, color: Color(0xFF4FC3B7)),
              title: Text('계정 정보'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF4FC3B7)),
              title: Text('참여 챌린지'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF4FC3B7)),
              title: Text('환경설정'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF4FC3B7)),
              title: Text('로그아웃'),
              onTap: () {},
            ),
          ],
        ),
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