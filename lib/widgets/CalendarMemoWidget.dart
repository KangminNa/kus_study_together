import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarMemoWidget extends StatefulWidget {
  const CalendarMemoWidget({Key? key}) : super(key: key);

  @override
  _CalendarMemoWidgetState createState() => _CalendarMemoWidgetState();
}

class _CalendarMemoWidgetState extends State<CalendarMemoWidget> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  TextEditingController memoController = TextEditingController();
  Map<DateTime, String> memos = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
    loadMemos(); // 앱 시작 시 Firestore에서 메모 데이터 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2021, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: focusedDay,
          onDaySelected: _onDaySelected,
          selectedDayPredicate: (DateTime day) {
            return isSameDay(selectedDay, day);
          },
          eventLoader: (DateTime date) {
            // Check if there is a memo for the selected day
            return memos[date] != null ? [true] : [];
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                loadMemos();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
      memoController.text = memos[selectedDay] ?? '';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('메모 작성'),
          content: TextField(
            controller: memoController,
            decoration: const InputDecoration(labelText: '간단한 메모를 작성하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                saveMemo();
                Navigator.of(context).pop();
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void saveMemo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user_memos')
          .doc(user.uid)
          .set({
        DateFormat('yyyy-MM-dd').format(selectedDay): memoController.text,
      }, SetOptions(merge: true));

      setState(() {
        memos[selectedDay] = memoController.text;
      });
    }
  }

  void loadMemos() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('user_memos')
          .doc(user.uid)
          .get();

      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          memos = data.map((key, value) {
            return MapEntry(DateTime.parse(key), value as String);
          });
        });
      }
    }
  }
}
