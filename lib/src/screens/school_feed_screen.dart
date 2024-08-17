import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/services/feed_service.dart';

class SchoolFeedScreen extends StatelessWidget {
  final String schoolId;
  final String schoolName;

  SchoolFeedScreen({required this.schoolId, required this.schoolName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolName),  // 상단에 학교 이름 표시
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FeedService().getPostsBySchool(schoolId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // 데이터 로딩 중
          }

          if (snapshot.hasError) {
            print('Error loading posts: ${snapshot.error}');
            return Center(child: Text('피드를 불러오는 중 문제가 발생했습니다.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('이 학교에 해당하는 피드가 없습니다.'));
          }

          var posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return PostItem(
                nickname: post['nickname'],
                content: post['content'],
                imageUrl: post['image_url'],
                createdAt: post['created_at'].toDate(),
              );
            },
          );
        },
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final String nickname;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  PostItem({required this.nickname, required this.content, this.imageUrl, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(nickname[0].toUpperCase()), // 프로필 이미지 대체
                ),
                SizedBox(width: 10),
                Text(
                  nickname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Text(
                  '${createdAt.month}/${createdAt.day}/${createdAt.year}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (imageUrl != null)
              Image.network(imageUrl!),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}