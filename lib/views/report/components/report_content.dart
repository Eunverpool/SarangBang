import 'package:flutter/material.dart';

class ReportContent extends StatelessWidget {
  const ReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' 대화 내용 요약',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        const Text(
          '오늘은 날씨가 맑고 좋았습니다. 아침에 일어나서 산책을 다녀왔고, 점심으로는 김치찌개를 먹었습니다. 오후에는 텔레비전에서 좋아하는 프로그램을 시청했습니다. 오늘은 전반적으로 기분이 평안하고 안정된 느낌이 들었습니다. 내일은 친구를 만나기로 했습니다.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        const Text(' 감정 분석',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                flex: 6, child: Container(height: 10, color: Colors.green)),
            Expanded(flex: 2, child: Container(height: 10, color: Colors.blue)),
            Expanded(
                flex: 2, child: Container(height: 10, color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 4),
        const Text('행복: 60%   평온: 25%   슬픔: 15%'),
        const SizedBox(height: 20),
        const Text(' 인지 테스트 결과',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• 날짜 인식: 정확함', style: TextStyle(color: Colors.green)),
              Text('• 최근 식사 회상: 정확함', style: TextStyle(color: Colors.green)),
              Text('• 기억력 회상: 정확함', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text('되돌아가기'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('저장하기'),
            ),
          ],
        ),
      ],
    );
  }
}
