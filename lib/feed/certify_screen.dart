import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zero_c/controller/Cfeed.dart';
import 'package:zero_c/data/Mfeed.dart';
import 'feed_screen.dart';
import 'dart:typed_data';

class CertifyScreen extends StatefulWidget {
  @override
  _CertifyScreenState createState() => _CertifyScreenState();
}

class _CertifyScreenState extends State<CertifyScreen> {
  final _textController = TextEditingController();
  final FeedController _feedController = FeedController();
  Uint8List? _feedImage;  // 이미지 데이터를 Uint8List로 받음
  User? _currentUser;
  String? _username;
  String? _schoolId;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _username = userDoc['name'];
        _schoolId = userDoc['school_id'];
      });
    } else {
      _username = 'Unknown';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _feedImage = bytes;
      });
    } else {
      Fluttertoast.showToast(
        msg: "이미지 선택이 취소되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _submitPost() async {
    if (_textController.text.isNotEmpty && _feedImage != null && _username != null && _schoolId != null) {
      final newPost = PostData(
        userId: _currentUser?.uid ?? "Unknown",
        challengeId: "4",
        username: _username!,
        content: _textController.text,
        profileImage: null,  // 프로필 이미지를 업로드하는 부분은 생략됨
        feedImage: null,  // 이미지 URL은 나중에 추가됨
        createAt: DateTime.now(),
        schoolId: _schoolId!,
        like: 0
      );

      await _feedController.addPost(newPost, _feedImage);

      Fluttertoast.showToast(
        msg: "게시글이 성공적으로 업로드되었습니다!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FeedScreen(
            schoolId: _schoolId!, 
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "내용을 입력하고 이미지를 업로드해주세요.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 인증'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                color: Colors.grey[300],
                height: 200,
                child: Center(
                  child: _feedImage != null
                      ? Image.memory(_feedImage!)
                      : Text('클릭하여 사진 업로드'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요',
                ),
                maxLines: null,
              ),
            ),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}
