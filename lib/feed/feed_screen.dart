import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zero_c/controller/Cfeed.dart';
import 'package:zero_c/controller/Cschool.dart';
import 'package:zero_c/data/Mschool.dart';
import 'package:zero_c/data/post_data.dart';
import 'package:zero_c/feed/post_card.dart';
import 'package:zero_c/rank/home_screen.dart';

class FeedScreen extends StatefulWidget {
  final String schoolId;

  FeedScreen({
    required this.schoolId,
  });

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

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      // schoolId에 해당하는 게시글들을 불러옴
      final loadedPosts =
          await _feedController.getPostsBySchool(widget.schoolId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시되는 인디케이터
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
                          backgroundImage: AssetImage('assets/mju.jpg'),
                        ),
                      ),
                    ),
                  ),
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
