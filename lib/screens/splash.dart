import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kus_study_together/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 로그인 화면으로 이동
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '공모전, 모임, 스터디 학교 일정',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(128, 0, 0, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '한곳에서 정리하자!',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(128, 0, 0, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'KUSTUDY',
              style: TextStyle(
                fontSize: 40,
                color: Color.fromRGBO(128, 0, 0, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset(
                'assets/images/kus2.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
