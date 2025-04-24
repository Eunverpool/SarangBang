import 'package:flutter/material.dart';

class ReportHeader extends StatelessWidget implements PreferredSizeWidget {
  final DateTime date;
  const ReportHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        '오늘의 일기',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              _formatKoreanDate(date),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // 한국어 날짜 포맷 함수
  String _formatKoreanDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final weekday = weekdays[date.weekday - 1];
    return '$year년 $month월 $day일 $weekday요일';
  }
}
