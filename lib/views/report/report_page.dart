import 'package:flutter/material.dart';
import 'package:grocery/views/report/components/report_header.dart';
import 'package:grocery/views/report/components/report_button.dart';
import 'package:grocery/views/report/components/report_summary.dart';
import 'package:grocery/views/report/components/report_emotion.dart';
import 'package:grocery/views/report/components/report_cognitivetest.dart';
import 'package:grocery/views/report/components/report_mentalstatus.dart';
import '../../core/constants/constants.dart';

import '../../data/report_data.dart';

class ReportPage extends StatelessWidget {
  final DateTime selectedDate;
  const ReportPage({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final report = getReportByDate(selectedDate);
    // report null 체크하고 넘기기
    if (report == null) {
      return const Center(child: Text('해당 날짜의 보고서가 없습니다.'));
    }

    return Scaffold(
      appBar: ReportHeader(date: selectedDate),
      body: SingleChildScrollView(
        // ✅ 스크롤 가능하게 변경
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportSummary(summary: report.summary),
            const SizedBox(height: 50),
            ReportEmotion(emotionRatio: report.emotionRatio),
            const SizedBox(height: 20),
            ReportMentalStatus(
              cognitiveResult: '정상',
              depressionScore: 0.65,
            ),
            const SizedBox(height: 20),
            const ReportCognitive(),
            const SizedBox(height: 20),
            const ReprotButton(),
          ],
        ),
      ),
    );
  }
}
