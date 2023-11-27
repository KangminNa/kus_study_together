import 'package:flutter/material.dart';
import 'package:kus_study_together/screens/home.dart';
import 'package:kus_study_together/screens/meetings.dart';
import 'package:kus_study_together/screens/studylist.dart';
import 'package:kus_study_together/screens/mypage.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = [
    const Home(),
    const StudyList(),
    const Meetings(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue, // Set the color for selected item
          unselectedItemColor:
              Colors.grey, // Set the color for unselected items
          backgroundColor: Colors.white, // Set the background color
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index); // 페이지 전환 추가
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '스터디',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: '참가모임',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('앱 종료'),
            content: const Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('예'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
