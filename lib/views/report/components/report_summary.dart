import 'package:flutter/material.dart';

class ReportSummary extends StatelessWidget {
  final String summary;
  const ReportSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('대화 내용 요약',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12), // 텍스트 주변에 여백 추가
          decoration: BoxDecoration(
            color: Colors.blueGrey[50], // 배경색 지정
            borderRadius: const BorderRadius.all(Radius.circular(8)), // 모서리 둥글게
          ),
          child: Text(
            summary,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
