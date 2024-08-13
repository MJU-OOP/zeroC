import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../rank/home_screen.dart';
import 'Login.dart';
import 'SignUp.dart';
// import 'StudentVerification.dart';
// import 'Nickname.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Login and Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginSignupFlow(),
    );
  }
}

class LoginSignupFlow extends StatefulWidget {
  const LoginSignupFlow({super.key});

  @override
  _LoginSignupFlowState createState() => _LoginSignupFlowState();
}

class _LoginSignupFlowState extends State<LoginSignupFlow> {
  final PageController _pageController = PageController();

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onLoginSuccess(UserCredential userCredential) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable manual swipe
        children: [
          Login(
            onSignupPressed: () => _goToPage(1),
            onLoginSuccess: _onLoginSuccess,
          ),
          SignUp(onVerificationComplete: () => _goToPage(2)),
          // StudentVerification(onVerificationComplete: () => _goToPage(3)),
          // const Nickname(),
        ],
      ),
    );
  }
}
