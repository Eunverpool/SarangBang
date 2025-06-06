import 'package:flutter/material.dart';

class ReportMentalStatus extends StatelessWidget {
  final String depressionResult; // 예: '정상' 또는 '의심'
  final String cognitiveResult; // 예: "0.65"

  const ReportMentalStatus({
    super.key,
    required this.cognitiveResult,
    required this.depressionResult,
  });

  @override
  Widget build(BuildContext context) {
    // 🟩 우울 상태 색상 로직
    Color getDepressionColor(String result) {
      switch (result) {
        case '정상':
          return Colors.green;
        case '의심':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
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
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 상태 박스들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 우울 상태 박스
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
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
                      '우울 테스트 결과',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    CircleAvatar(
                      backgroundColor:
                          getDepressionColor(depressionResult).withOpacity(0.2),
                      radius: 24,
                      child: Icon(
                        Icons.check_circle,
                        color: getDepressionColor(depressionResult),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      depressionResult,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: getDepressionColor(depressionResult),
                      ),
                    ),
                    const Text('우울 상태'),
                  ],
                ),
              ),
            ),

            // 인지 상태 박스
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
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
                      backgroundColor: getDepressionColor(cognitiveResult),
                      radius: 24,
                      child: Icon(
                        Icons.check_circle,
                        color: getDepressionColor(cognitiveResult),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cognitiveResult,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: getDepressionColor(cognitiveResult),
                      ),
                    ),
                    const Text('인지 상태'),
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
