import 'package:flutter/material.dart';

class ReportEmotion extends StatelessWidget {
  final Map<String, double> emotionRatio;
  const ReportEmotion({super.key, required this.emotionRatio});

  @override
  Widget build(BuildContext context) {
    // 고정된 색상 리스트 (빨강, 파랑, 주황 순으로 반복)
    final colors = [Color(0xFFF34B4B), Color(0xFF4B91F3), Color(0xFFF3B94B)];

    final total = emotionRatio.values.fold(0.0, (sum, value) => sum + value);
    final entries = emotionRatio.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 텍스트와 세로선 가로배치 (Container 위에 위치)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: Color(0xFF00A572),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '감정 분석',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 기존 Container (감정 박스)
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 퍼센트 바 (둥글게)
              Row(
                children: List.generate(entries.length, (i) {
                  final percent = (entries[i].value / total * 100).round();

                  BorderRadius borderRadius = BorderRadius.zero;
                  if (i == 0) {
                    borderRadius = const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    );
                  } else if (i == entries.length - 1) {
                    borderRadius = const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    );
                  }

                  return Expanded(
                    flex: percent,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: borderRadius,
                      ),
                      child: Center(
                        child: Text(
                          '$percent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // 감정 카드 (아래)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(entries.length, (i) {
                  final entry = entries[i];
                  final percent = (entry.value / total * 100).round();
                  final color = colors[i % colors.length];

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          CircleIndicator(color: color),
                          const SizedBox(height: 4),
                          Text(entry.key, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            '$percent%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class CircleIndicator extends StatelessWidget {
  final Color color;
  const CircleIndicator({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
