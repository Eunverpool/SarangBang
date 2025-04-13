import 'package:flutter/material.dart';

class reportCognitive extends StatelessWidget {
  const reportCognitive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('인지 테스트 결과',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
              Text('• 날짜 인식: 정확함', style: TextStyle(color: Colors.black)),
              Text('• 최근 식사 회상: 정확함', style: TextStyle(color: Colors.black)),
              Text('• 기억력 회상: 정확함', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
