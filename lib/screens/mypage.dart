import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kus_study_together/screens/login_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  // 로그아웃 함수
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase Authentication으로 로그아웃
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // 로그인 화면으로 이동
        ),
      );
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('내가 작성한 글'),
              onTap: () {
                // TODO: Navigate to the page showing user's posts
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('내가 참여한 모임'),
              onTap: () {
                // TODO: Navigate to the page showing user's joined meetings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('개인정보 수정'),
              onTap: () {
                // TODO: Navigate to the page for editing user profile
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () {
                _signOut(context); // 로그아웃 함수 호출
              },
            ),
          ],
        ),
      ),
    );
  }
}
