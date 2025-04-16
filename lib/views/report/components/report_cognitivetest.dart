import 'package:flutter/material.dart';

class ReportCognitive extends StatelessWidget {
  const ReportCognitive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('인지 테스트 결과',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black)),
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
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21),
                  children: [
                    const TextSpan(
                      text: '• 날짜 인식: ',
                      style: TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
                      text: '정확',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21),
                  children: [
                    const TextSpan(
                      text: '• 최근 식사 회상: ',
                      style: TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
                      text: '정확',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21),
                  children: [
                    const TextSpan(
                      text: '• 기억력 회상: ',
                      style: TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
                      text: '부정확',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
