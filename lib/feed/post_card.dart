import 'package:flutter/material.dart';

import '../data/post_data.dart';

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
              backgroundImage: post.profileImage != null 
                ? MemoryImage(post.profileImage!)
                : const AssetImage('assets/blank.png') as ImageProvider,
            ),
            title: Text(post.username),
            subtitle: Text(post.createAt),
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
}
