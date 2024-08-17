import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/services/feed_service.dart';

class SchoolFeedScreen extends StatelessWidget {
  final String schoolId;

  SchoolFeedScreen({required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('학교 피드')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FeedService().getPostsBySchool(schoolId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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

  PostItem({required this.nickname, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            if (imageUrl != null)
              Image.network(imageUrl!),
            SizedBox(height: 5),
            Text(content),
          ],
        ),
      ),
    );
  }
}