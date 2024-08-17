import 'package:flutter/material.dart';
import 'package:zeroC/src/services/feed_service.dart';
import 'package:zeroC/src/services/image_uploader.dart';
import 'package:zeroC/src/screens/school_rank_screen.dart';

class CreatePostScreen extends StatefulWidget {
  final String userId;
  final String nickname;
  final String schoolId;

  // CreatePostScreen 생성자 정의
  CreatePostScreen({
    required this.userId,
    required this.nickname,
    required this.schoolId,
  });

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  String? _uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게시물 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                _uploadedImageUrl = await ImageUploader().uploadImage(widget.userId);
                setState(() {});
              },
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: _uploadedImageUrl == null
                    ? Center(child: Text('클릭하여 사진 업로드'))
                    : Image.network(_uploadedImageUrl!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: '내용을 입력하세요'),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FeedService().createPost(
                    userId: widget.userId,
                    nickname: widget.nickname,
                    schoolId: widget.schoolId,
                    imageUrl: _uploadedImageUrl,
                    content: _contentController.text,
                  );

                  // 피드 생성 후 학교 랭킹 화면으로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SchoolRankScreen()),
                  );
                } catch (e) {
                  print('Error: $e');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('An error occurred while submitting the post.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}