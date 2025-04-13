import 'package:flutter/material.dart';

class ReportEmotion extends StatelessWidget {
  const ReportEmotion({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('💗 감정 분석',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                flex: 6,
                child: ColoredBox(
                    color: Colors.green, child: SizedBox(height: 10))),
            Expanded(
                flex: 2,
                child: ColoredBox(
                    color: Colors.blue, child: SizedBox(height: 10))),
            Expanded(
                flex: 2,
                child: ColoredBox(
                    color: Colors.orange, child: SizedBox(height: 10))),
          ],
        ),
        SizedBox(height: 4),
        Text('행복: 60%   평온: 25%   슬픔: 15%'),
      ],
    );
  }
}
