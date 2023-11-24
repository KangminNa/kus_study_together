import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kus_study_together/widgets/CalendarMemoWidget.dart';
import 'package:table_calendar/table_calendar.dart';

class FirstMain extends StatefulWidget {
  const FirstMain({Key? key}) : super(key: key);

  @override
  State<FirstMain> createState() => _FirstMainState();
}

class _FirstMainState extends State<FirstMain> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: user != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user.email}님 안녕하세요!',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : null,
          backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(32.0),
              child: CalendarMemoWidget(),
            ),
            // 추가적인 위젯이 필요하다면 여기에 추가하세요.
          ],
        ),
      ),
    );
  }
}
