// meetings.dart

import 'package:flutter/material.dart';

class Meetings extends StatelessWidget {
  const Meetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임관리'),
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: const Center(
        child: Text('Meetings Page Content'),
      ),
    );
  }
}
