import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeroC/src/screens/school_rank_screen.dart';
import 'package:zeroC/src/screens/profile_screen.dart';
import 'package:zeroC/src/screens/create_post_screen.dart';
import 'package:zeroC/src/services/user_service.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  MainLayout({required this.child, required this.currentIndex});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? userId;
  String? nickname;
  String? schoolId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // FirebaseAuth에서 로그인된 사용자 ID 가져오기
    userId = FirebaseAuth.instance.currentUser?.uid;

    // Firestore에서 사용자 정보 가져오기
    if (userId != null) {
      Map<String, dynamic>? userInfo = await UserService().getUserInfo();

      if (userInfo != null) {
        setState(() {
          nickname = userInfo['nick_name'];
          schoolId = userInfo['school_id'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              if (userId != null && nickname != null && schoolId != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(
                      userId: userId!,
                      nickname: nickname!,
                      schoolId: schoolId!,
                    ),
                  ),
                );
              } else {
                // 사용자 정보가 없을 경우 에러 처리
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('사용자 정보를 불러오지 못했습니다.')),
                );
              }
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SchoolRankScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: '인증',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이 페이지',
          ),
        ],
      ),
    );
  }
}