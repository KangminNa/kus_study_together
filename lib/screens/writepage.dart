import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int? _selectedStudyFrequency;
  bool _isSaveButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(128, 0, 0, 0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _titleController,
              onChanged: (_) => _validateInputs(),
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _participantsController,
              onChanged: (_) => _validateInputs(),
              decoration: const InputDecoration(
                labelText: '인원수',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        _startDateController.text =
                            selectedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    child: TextField(
                      controller: _startDateController,
                      onChanged: (_) => _validateInputs(),
                      decoration: const InputDecoration(
                        labelText: '시작 날짜',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        _endDateController.text =
                            selectedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    child: TextField(
                      controller: _endDateController,
                      onChanged: (_) => _validateInputs(),
                      decoration: const InputDecoration(
                        labelText: '종료 날짜',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                '만남주기(일주일 몇 회)',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: List.generate(
                7,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedStudyFrequency =
                              _selectedStudyFrequency == index + 1
                                  ? null
                                  : index + 1;
                        });
                        _validateInputs();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedStudyFrequency == index + 1
                            ? const Color.fromRGBO(128, 0, 0, 0.7)
                            : Colors.white,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _selectedStudyFrequency == index + 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              onChanged: (_) => _validateInputs(),
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: '내용을 입력하세요',
                hintText: '',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isSaveButtonEnabled ? _savePost : null,
                      child: const Text('저장'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      _isSaveButtonEnabled = _titleController.text.isNotEmpty &&
          _participantsController.text.isNotEmpty &&
          _startDateController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty &&
          _contentController.text.isNotEmpty &&
          _selectedStudyFrequency != null;
    });
  }

  void _savePost() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('study_posts').add({
        'title': _titleController.text,
        'participants': _participantsController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'frequency': _selectedStudyFrequency?.toString(),
        'content': _contentController.text,
        'email': user.email,
        'member': [],
      });

      Navigator.pop(context);
    } else {
      print('User not logged in');
    }
  }
}
