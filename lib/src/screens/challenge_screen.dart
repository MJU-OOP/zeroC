import 'package:flutter/material.dart';
import 'package:zeroC/src/components/main_layout.dart';

class ChallengeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Center(
        child: Text('이번 주 챌린지: 텀블러 사용'),
      ),
    );
  }
}