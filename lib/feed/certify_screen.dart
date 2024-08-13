import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../data/post_data.dart';
import '../database/firebase_helper.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'feed_screen.dart'; // FeedScreen을 import 합니다.

class CertifyScreen extends StatefulWidget {
  @override
  _CertifyScreenState createState() => _CertifyScreenState();
}

class _CertifyScreenState extends State<CertifyScreen> {
  final _textController = TextEditingController();
  Uint8List? _profileImage;
  Uint8List? _feedImage;
  User? _currentUser;
  String? _username;
  String? _schoolId; // 학교 ID를 저장

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData(); // 사용자 정보 로드
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _username = userDoc['name'];
        _schoolId = userDoc['school_id']; // 유저 문서에서 school_id 가져오기
      });
    } else {
      _username = 'Unknown';
    }
  }

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isProfile) {
          _profileImage = bytes;
        } else {
          _feedImage = bytes;
        }
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
    if (_textController.text.isNotEmpty &&
        _feedImage != null &&
        _username != null &&
        _schoolId != null) {
      final newPost = PostData(
        userId: _currentUser?.uid ?? "Unknown",
        challengeId: "4",
        username: _username!, // Firestore에서 가져온 사용자 이름
        content: _textController.text,
        profileImage: _profileImage,
        feedImage: _feedImage,
        createAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        schoolId: _schoolId!, // schoolId 저장
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.addPost(newPost);

      Fluttertoast.showToast(
        msg: "게시글이 성공적으로 업로드되었습니다!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // 게시글 작성 후 FeedScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FeedScreen(
            schoolId: "", // 필요에 따라 school 매개변수를 설정
            schoolImageUrl: "",
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
              onTap: () => _pickImage(false),
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
                maxLines: null, // 여러 줄 입력 가능
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
