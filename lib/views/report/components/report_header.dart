import 'package:flutter/material.dart';

class ReportHeader extends StatelessWidget implements PreferredSizeWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); // 뒤로 가기 기능
        },
      ),
      title: const Text(
        '오늘의 일기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // 글씨 굵게 설정
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '2025년 3월 20일 목요일',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold, // 글씨 굵게 설정
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
