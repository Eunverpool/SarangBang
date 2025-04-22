import 'package:flutter/material.dart';

class ReportEmotion extends StatelessWidget {
  final Map<String, int> emotionRatio;
  const ReportEmotion({super.key, required this.emotionRatio});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.green, Colors.blue, Colors.orange];
    final keys = emotionRatio.keys.toList();
    final values = emotionRatio.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('감정 분석',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(values.length, (i) {
            return Expanded(
              flex: values[i],
              child: Container(
                height: 20,
                color: colors[i % colors.length],
              ),
            );
          }),
          // [
          //   Expanded(
          //       flex: 6,
          //       child: Container(
          //         color: Colors.green,
          //         height: 20,
          //       )),
          //   Expanded(
          //       flex: 2,
          //       child: Container(
          //         color: Colors.blue,
          //         height: 20,
          //       )),
          //   Expanded(
          //       flex: 2,
          //       child: Container(
          //         color: Colors.orange,
          //         height: 20,
          //       )),
          // ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(keys.length, (i) {
            return Row(
              children: [
                CircleIndicator(color: colors[i % colors.length]),
                const SizedBox(width: 4),
                Text('${keys[i]}: ${values[i]}%',
                    style: const TextStyle(fontSize: 21)),
                const SizedBox(width: 8),
              ],
            );
          }),
          // [
          //   CircleIndicator(color: Colors.green),
          //   SizedBox(width: 4),
          //   Text('행복: 60%',
          //       style: TextStyle(fontSize: 21, color: Colors.black)),
          //   SizedBox(width: 8),
          //   CircleIndicator(color: Colors.blue),
          //   SizedBox(width: 4),
          //   Text('평온: 25%',
          //       style: TextStyle(fontSize: 21, color: Colors.black)),
          //   SizedBox(width: 8),
          //   CircleIndicator(color: Colors.orange),
          //   SizedBox(width: 4),
          //   Text('와짜: 15%',
          //       style: TextStyle(fontSize: 21, color: Colors.black)),
          // ],
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
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
