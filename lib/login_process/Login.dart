import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  final VoidCallback onSignupPressed;
  final Function(UserCredential) onLoginSuccess;  // 콜백 타입 변경

  const Login({
    super.key,
    required this.onSignupPressed,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> login() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        onLoginSuccess(userCredential);  // 수정된 콜백 호출
        Fluttertoast.showToast(
        msg: 'Logged in successfully: ${userCredential.user?.email}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided.');
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('지구를 지키러 온 당신! 반영해요~'),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: '이메일',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: '비밀번호',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: login,
            child: const Text('로그인'),
          ),
          TextButton(
            onPressed: onSignupPressed,
            child: const Text('아직 회원이 아니신가요? 회원가입'),
          ),
        ],
      ),
    );
  }
}
