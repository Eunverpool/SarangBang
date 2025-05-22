import 'package:flutter/material.dart';

class ReportCognitive extends StatelessWidget {
  const ReportCognitive({super.key});

  final List<Map<String, dynamic>> results = const [
    {"label": "날짜 인식", "result": "정확", "color": Colors.green},
    {"label": "최근 식사 회상", "result": "정확", "color": Colors.green},
    {"label": "기억력 회상", "result": "부정확", "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 타이틀
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              '인지 테스트 결과',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 인지 테스트 박스
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 초록색 상단 선
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A572),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),

              // 결과 항목들
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(results.length, (index) {
                  final e = results[index];
                  final Color resultColor = e["color"];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 4),
                        child: Row(
                          children: [
                            // 왼쪽 상태 점
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: resultColor,
                                shape: BoxShape.circle,
                              ),
                            ),

                            // 라벨 텍스트
                            Expanded(
                              child: Text(
                                e["label"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            // 오른쪽 결과 박스 (테두리 없음)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: resultColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                e["result"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: resultColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != results.length - 1)
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[300]),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
