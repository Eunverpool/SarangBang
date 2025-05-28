import 'package:flutter/material.dart';

class ReportMentalStatus extends StatelessWidget {
  final String cognitiveResult; // 예: '정상'
  final double depressionScore; // 예: 0.65

  const ReportMentalStatus({
    super.key,
    required this.cognitiveResult,
    required this.depressionScore,
  });

  @override
  Widget build(BuildContext context) {
    final isHighDepression = depressionScore >= 0.6;
    final depressionPercent = (depressionScore * 100).toStringAsFixed(1);
    final depressionColor = isHighDepression ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 + 세로 라인
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF00A572),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '정신 건강 상태',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row로 인지 상태 박스와 우울증 상태 박스를 나란히 배치
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🟩 인지 상태 박스
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '인지 테스트 결과',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    CircleAvatar(
                      backgroundColor: Colors.green[100],
                      radius: 24,
                      child: const Icon(Icons.check_circle,
                          color: Colors.green, size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cognitiveResult,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text('인지 기능 상태'),
                  ],
                ),
              ),
            ),

            // 🟥 우울증 상태 박스
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '우울증 검사',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$depressionPercent%',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: depressionScore,
                      color: depressionColor,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHighDepression ? '높음 (0.0 - 1.0)' : '낮음 (0.0 - 1.0)',
                      style: TextStyle(
                        color: depressionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
