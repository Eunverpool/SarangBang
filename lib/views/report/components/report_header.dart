import 'package:flutter/material.dart';

class ReportHeader extends StatelessWidget implements PreferredSizeWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '📅 2025년 3월 20일 목요일',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
