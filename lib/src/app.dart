import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeroC/src/screens/school_rank_screen.dart'; // 새로 추가된 파일
import 'package:zeroC/src/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getInitialScreen(), // 초기 화면 설정
    );
  }

  Widget _getInitialScreen() {
    User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
  return SchoolRankScreen(); // 사용자 로그인된 경우 순위 페이지로 이동
} else {
  return LoginScreen(); // 로그인되지 않은 경우
}
  }
}