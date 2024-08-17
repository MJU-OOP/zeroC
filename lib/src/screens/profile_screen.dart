import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeroC/src/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut(); // 로그아웃
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // 로그인 화면으로 이동
            );
          },
          child: Text('로그아웃'),
        ),
      ),
    );
  }
}