import 'package:flutter/material.dart';

class ReportSummary extends StatelessWidget {
  const ReportSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('대화 내용 요약',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12), // 텍스트 주변에 여백 추가
          decoration: BoxDecoration(
            color: Colors.blueGrey[50], // 배경색 지정
            borderRadius: const BorderRadius.all(Radius.circular(8)), // 모서리 둥글게
          ),
          child: const Text(
            '오늘은 날씨가 맑고 좋았습니다. 아침에 일어나서 산책을 다녀왔고, 점심으로는 김치찌개를 먹었습니다. 오후에는 텔레비전에서 좋아하는 프로그램을 시청했습니다. 오늘은 전반적으로 기분이 평안하고 안정된 느낌이 들었습니다. 내일은 친구를 만나기로 했습니다.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
