import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kus_study_together/screens/studylist.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String participants;
  final String frequency;
  final String startDate;
  final String endDate;
  final String email;
  final List member;

  const DetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.participants,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.email,
    required this.member,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int participantsCount;
  late bool isParticipant;

  @override
  void initState() {
    super.initState();
    participantsCount = widget.participants.split(',').length;
    isParticipant = widget.member.contains(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 내용'),
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: _buildContentCard(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '참가한 사용자 목록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // ListView.builder를 사용하여 멤버 목록을 타일 형태로 표시
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.member.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.member[index]),
                  // 여기에 타일을 터치할 때 수행할 동작을 추가할 수 있습니다.
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '작성자 : ${widget.email}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                Text(
                  '인원 수 제한: $participantsCount',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  '스터디 기간: ${widget.startDate} ~ ${widget.endDate}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(Icons.repeat),
                const SizedBox(width: 8),
                Text(
                  '스터디 주기: ${widget.frequency}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('스터디 내용:'),
            const SizedBox(height: 8),
            Text(widget.content),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _joinStudy(context),
                  child: const Text('스터디 참가'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _joinStudy(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (widget.email == user!.email || widget.member.contains(user.email)) {
      // 이미 참가한 사용자라면 다이얼로그로 알림
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림'),
          content: const Text('본인이 작성한 글이거나\n이미 참가한 모임입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      // Firestore에서 해당 이메일을 포함하는 문서를 찾음
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('study_posts')
          .where('email', isEqualTo: widget.email)
          .get();

      // 해당 문서의 ID를 가져오기
      String? documentId;
      if (querySnapshot.docs.isNotEmpty) {
        documentId = querySnapshot.docs.first.id;
      }

      if (documentId != null) {
        // 새로운 참가자인 경우 참가자 추가 후 다이얼로그로 알림
        setState(
          () {
            widget.member.add(user.email);
          },
        );
        // Firestore에서 해당 문서의 member 필드 업데이트
        FirebaseFirestore.instance
            .collection('study_posts')
            .doc(documentId)
            .update({
          'member': FieldValue.arrayUnion([user.email]),
        });
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('알림'),
            content: const Text('스터디에 참가되었습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그를 닫음
                  Navigator.of(context).pop(); // 이전 화면(StudyList)으로 이동
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }
}
