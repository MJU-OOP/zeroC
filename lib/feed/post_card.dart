import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zero_c/controller/Cfeed.dart';
import 'package:zero_c/data/Mfeed.dart';

class PostCard extends StatefulWidget {
  final PostData post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  final FeedController _feedController = FeedController();
  bool _isProcessing = false; // 서버 통신 중인지 여부를 나타내는 플래그

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.like;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    bool liked =
        await _feedController.checkIfLiked(widget.post, widget.post.userId);
    setState(() {
      _isLiked = liked;
    });
  }

  Future<void> _toggleLike() async {
    if (_isProcessing) return; // 서버와 통신 중이면 다른 요청을 막음

    setState(() {
      _isProcessing = true;
    });

    bool success = false;
    int retryCount = 0;
    const maxRetries = 3; // 최대 재시도 횟수

    while (!success && retryCount < maxRetries) {
      try {
        await _feedController.updateLike(widget.post, widget.post.userId);
        success = true;
        setState(() {
          _isLiked = !_isLiked;
          _likeCount += _isLiked ? 1 : -1;
        });
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          // 재시도 최대 횟수를 넘으면 사용자에게 오류를 알림
          Fluttertoast.showToast(
            msg: "서버와의 연결에 실패했습니다. 다시 시도해주세요.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    }

    setState(() {
      _isProcessing = false;
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
              Text('$_likeCount'), // 좋아요 수 표시
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
      return const AssetImage('assets/blank.png'); // 기본 이미지 제공
    }
  }
}
