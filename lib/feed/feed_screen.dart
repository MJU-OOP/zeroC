import 'package:flutter/material.dart';
import '../data/post_data.dart';
import '../database/firebase_helper.dart';
import '../rank/home_screen.dart';
import 'post_card.dart';

class FeedScreen extends StatefulWidget {
  final String schoolId;
  final String schoolImageUrl;

  FeedScreen({required this.schoolId, required this.schoolImageUrl});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostData> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final dbHelper = DatabaseHelper();
    final loadedPosts = await dbHelper.getPosts(); // Firestore에서 모든 데이터를 가져옴
    setState(() {
      posts = loadedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
              title: Text(widget.schoolId),
              background: Container(
                color: Colors.white,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(widget.schoolImageUrl),
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
