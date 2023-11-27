import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kus_study_together/screens/writepage.dart';

class StudyList extends StatelessWidget {
  const StudyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임 참가'),
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('study_posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return ListTile(
                title: Text(post['content']),
                // Add other information as needed
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WritePage(),
            ),
          );
        },
        tooltip: 'Write',
        child: const Icon(Icons.edit),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndFloat, // 위치 조정
    );
  }
}
