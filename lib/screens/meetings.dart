import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kus_study_together/screens/chatpage.dart';

class Meetings extends StatefulWidget {
  const Meetings({Key? key}) : super(key: key);

  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  List<String> meetingList = [];
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    // 현재 사용자의 이메일을 가져오거나 사용자 관리 방식에 따라 적절한 방법으로 가져옵니다.
    String? userEmail = user!.email;

    try {
      // Firestore에서 study_posts 데이터 가져오기
      QuerySnapshot<Map<String, dynamic>> meetingsSnapshot =
          await FirebaseFirestore.instance.collection('study_posts').get();

      // 현재 사용자의 이메일이 study_posts의 member 목록에 있는지 확인
      List<String> userMeetings = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> meeting
          in meetingsSnapshot.docs) {
        List<dynamic>? members = meeting['member'];
        String? email = meeting['email'];

        if ((members != null && members.contains(userEmail)) ||
            (email != null && email == userEmail)) {
          userMeetings.add(meeting['title']);
        }
      }

      setState(() {
        meetingList = userMeetings;
      });
    } catch (e) {
      print('Error loading meetings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임관리'),
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: Center(
        child: meetingList.isEmpty
            ? const Text('참여 중인 스터디가 없습니다.')
            : ListView.builder(
                itemCount: meetingList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(meetingList[index]),
                      onTap: () {
                        // 선택한 스터디의 채팅 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(meetingList[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
