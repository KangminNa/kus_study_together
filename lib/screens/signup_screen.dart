import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kus_study_together/services/authentication_service.dart';
import 'package:kus_study_together/screens/login_screen.dart'; // 로그인 화면 파일 임포트

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    User? user = await _authenticationService.signUpWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      // 회원가입 성공
      print('회원가입 성공: ${user.email}');
      // 로그인 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // 로그인 화면으로 이동
        ),
      );
    } else {
      // 회원가입 실패
      print('회원가입 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이메일/비밀번호 회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                _signUpWithEmailAndPassword(context); // 회원가입 함수 호출
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
