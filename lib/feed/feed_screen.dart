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
  bool _isScrolled = false;

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
        loadedPosts =
            await _feedController.getPostsSortedByLikes(widget.schoolId);
      }

      final loadedSchool =
          await _schoolController.getSchoolById(widget.schoolId);

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
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          setState(() {
            _isScrolled = scrollInfo.metrics.pixels > 20;
          });
          return true;
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시되는 인디케이터
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.home,
                          color:
                              _isScrolled ? Colors.white : Color(0xFF4FC3B7)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    expandedHeight: 200.0,
                    pinned: true,
                    backgroundColor: _isScrolled
                        ? Color(0xFF4FC3B7) // 스크롤 후의 배경색 (초록색)
                        : Colors.white, // 스크롤 전의 배경색 (하얀색)
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(school.schoolName,
                          style: TextStyle(
                            color: _isScrolled
                                ? Colors.white
                                : Color(0xFF4FC3B7), // 스크롤 전후의 텍스트 색상
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          )),
                      background: Container(
                        color: Colors.white,
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(school.schoolImage!),
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
                        icon: Icon(Icons.sort,
                            color: _isScrolled
                                ? Colors.white
                                : Color(0xFF4FC3B7)), // 스크롤 전후의 아이콘 색상
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
      ),
    );
  }
}
