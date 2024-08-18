import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 패키지
import 'package:zero_c/data/Mfeed.dart';

class PostCard extends StatefulWidget {
  final PostData post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: _getProfileImage(widget.post.profileImage),
            ),
            title: Text(widget.post.username),
            subtitle: Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.post.createAt)),
          ),
          if (widget.post.feedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(widget.post.feedImage!),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.post.content),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: _isLiked ? Colors.greenAccent : Colors.grey,
                ),
                onPressed: _toggleLike,
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

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/blank.png');
    }
  }
}
