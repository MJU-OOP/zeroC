import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5V9zbYT1VgsJYv3T14VI0irKZmrczFwpCpg&s'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User12345', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('user123@gmail.com'),
                    Text('명지대학교'),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('프로필 수정'),
                    ),
                  ],
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('계정 정보'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('참여 챌린지'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('환경설정'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}