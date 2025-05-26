import 'package:flutter/material.dart';
import '../diary/components/calendar.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      appBar: AppBar(
        title: const Text('일기장'),
      ),
      body: const Center(
        child: DiaryCalendar(), // 컴포넌트 사용
      ),
    );
  }
}
