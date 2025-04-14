import 'package:flutter/material.dart';
import '../diary/components/calendar.dart';

class DiaryPage extends StatelessWidget {

  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기장'),
      ),
      body: const Center(
        child: DiaryCalendar(), // 컴포넌트 사용
      ),
    );
  }
}