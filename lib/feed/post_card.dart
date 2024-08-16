import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지
import 'package:zero_c/data/Mfeed.dart';

class PostCard extends StatelessWidget {
  final PostData post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: _getProfileImage(post.profileImage),
            ),
            title: Text(post.username),
            subtitle: Text(_formatDate(post.createAt)), // DateTime을 텍스트로 포맷팅하여 표시
          ),
          if (post.feedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(post.feedImage!),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.content),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage(Uint8List? image) {
    if (image != null) {
      return MemoryImage(image);
    } else {
      return const AssetImage('assets/blank.png');
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date); // 날짜를 'yyyy-MM-dd HH:mm' 포맷으로 표시
  }
}
