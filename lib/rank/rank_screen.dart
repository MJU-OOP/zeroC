import 'package:flutter/material.dart';
import '../data/post_data.dart';
import '../database/firebase_helper.dart';
import '../feed/certify_screen.dart';
import '../feed/post_card.dart';
import '../user/my_page_screen.dart';
import 'home_screen.dart';

class RankScreen extends StatefulWidget {
  final String school;
  final String schoolName;
  final String schoolImageUrl;

  RankScreen({required this.school, required this.schoolImageUrl, required this.schoolName});

  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  List<PostData> posts = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final dbHelper = DatabaseHelper();
    final loadedPosts = await dbHelper.getPostsBySchool(widget.school);
    setState(() {
      posts = loadedPosts;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    } else if (_currentIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CertifyScreen()),
      );
    } else if (_currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.school),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 200.0,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage(widget.schoolImageUrl), 나중에 혹시 다른 학교 추가하면 이걸로
                backgroundImage: AssetImage('assets/mju.jpg'),
              ),
            ),
          ),
          Expanded(
            child: posts.isEmpty
                ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('게시물이 없습니다.'),
              ),
            )
                : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: '인증',
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