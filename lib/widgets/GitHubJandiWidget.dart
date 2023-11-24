import 'package:flutter/material.dart';

class GitHubJandiWidget extends StatelessWidget {
  const GitHubJandiWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '오늘도 메모를 작성해보세요',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // GitHub 잔디를 나타내는 테이블
          Table(
            border: TableBorder.all(),
            children: List.generate(
              7, // 행의 수 (12개월)
              (rowIndex) => TableRow(
                children: List.generate(
                  16, // 열의 수 (일주일)
                  (colIndex) {
                    // 임의의 방식으로 잔디의 색상을 정할 수 있습니다.
                    Color color = (rowIndex + colIndex) % 3 == 0
                        ? Colors.green
                        : Colors.transparent;
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.rectangle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
