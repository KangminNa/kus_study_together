import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kus_study_together/services/authentication_service.dart';
import 'package:kus_study_together/screens/signup_screen.dart';
import 'package:kus_study_together/widgets/bottom_navigation.dart'; // SignupScreen 파일 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    User? user = await _authenticationService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      // 로그인 성공
      print('로그인 성공: ${user.email}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const BottomNavigation(), // BottomNavigation 화면으로 이동
        ),
      );
    } else {
      // 로그인 실패
      print('로그인 실패');
    }
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(), // SignupScreen으로 이동
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _signInWithEmailAndPassword,
                  child: const Text('로그인'),
                ),
                TextButton(
                  // 회원가입으로 이동할 버튼
                  onPressed: _navigateToSignup,
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
