import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kus_study_together/screens/login_screen.dart'; // 로그인 화면 파일 임포트

class ThirdMyPage extends StatelessWidget {
  const ThirdMyPage({super.key});

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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('로그인한 이메일: ${user?.email ?? '로그인되지 않았습니다'}'), // 로그인한 이메일 표시
          ElevatedButton(
            onPressed: () {
              _signOut(context); // 로그아웃 함수 호출
            },
            child: const Text('로그아웃'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('내가 작성한 글'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('내가 참여한 모임'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('개인정보 수정'),
          ),
        ],
      ),
    );
  }
}
