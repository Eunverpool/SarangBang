import 'package:flutter/material.dart';

class ReportEmotion extends StatelessWidget {
  const ReportEmotion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('감정 분석',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                flex: 6,
                child: Container(
                  color: Colors.green,
                  height: 10,
                )),
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blue,
                  height: 10,
                )),
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.orange,
                  height: 10,
                )),
          ],
        ),
        const SizedBox(height: 4),
        const Row(
          children: [
            CircleIndicator(color: Colors.green),
            SizedBox(width: 4),
            Text('행복: 60%',
                style: TextStyle(fontSize: 21, color: Colors.black)),
            SizedBox(width: 8),
            CircleIndicator(color: Colors.blue),
            SizedBox(width: 4),
            Text('평온: 25%',
                style: TextStyle(fontSize: 21, color: Colors.black)),
            SizedBox(width: 8),
            CircleIndicator(color: Colors.orange),
            SizedBox(width: 4),
            Text('와짜: 15%',
                style: TextStyle(fontSize: 21, color: Colors.black)),
          ],
        ),
      ],
    );
  }
}

class CircleIndicator extends StatelessWidget {
  final Color color;
  const CircleIndicator({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
