import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zero_c/controller/Cfeed.dart';
import 'package:zero_c/controller/Cschool.dart';
import 'package:zero_c/data/Mschool.dart';
import 'package:zero_c/data/Mfeed.dart';
import 'package:zero_c/feed/post_card.dart';
import 'package:zero_c/rank/home_screen.dart';

class FeedScreen extends StatefulWidget {
  final String schoolId;

  FeedScreen({required this.schoolId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FeedController _feedController = FeedController();
  final SchoolController _schoolController = SchoolController();
  List<PostData> posts = [];
  SchoolData school = SchoolData(
    schoolId: 'Unknown',
    schoolName: 'Unknown',
    schoolImage: null,
  );
  bool isLoading = true;
  String _sortOrder = 'latest'; // 기본 정렬 방식을 'latest'로 설정

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      List<PostData> loadedPosts = [];

      if (_sortOrder == 'latest') {
        loadedPosts = await _feedController.getPostsBySchool(widget.schoolId);
      } else if (_sortOrder == 'likes') {
        loadedPosts = await _feedController.getPostsSortedByLikes(widget.schoolId);
      }

      final loadedSchool = await _schoolController.getSchoolById(widget.schoolId);

      setState(() {
        posts = loadedPosts;
        if (loadedSchool != null) {
          school = loadedSchool;
        } else {
          print("Failed to load school data");
        }
        isLoading = false; // 데이터를 성공적으로 불러온 후 로딩 상태 해제
      });
    } catch (e) {
      // 에러 발생 시에도 로딩 상태 해제하고 에러 메시지를 사용자에게 표시
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _changeSortOrder(String newSortOrder) {
    setState(() {
      _sortOrder = newSortOrder;
      isLoading = true;
    });
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시되는 인디케이터
          : posts.isEmpty
          ? Center(child: Text("게시글이 없습니다.")) // 데이터가 없을 때 표시되는 메시지
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(school.schoolName),
              background: Container(
                color: Colors.white,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: school.schoolImage != null
                        ? NetworkImage(school.schoolImage!)
                        : AssetImage('assets/default_school.png') as ImageProvider,
                  ),
                ),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: _changeSortOrder,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'latest',
                    child: Text('Latest'),
                  ),
                  PopupMenuItem(
                    value: 'likes',
                    child: Text('Most Liked'),
                  ),
                ],
                icon: Icon(Icons.sort),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return PostCard(
                  post: posts[index],
                );
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}