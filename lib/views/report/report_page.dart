import 'package:flutter/material.dart';
import 'package:grocery/views/report/components/report_header.dart';
import 'package:grocery/views/report/components/report_button.dart';
import 'package:grocery/views/report/components/report_summary.dart';
import 'package:grocery/views/report/components/report_emotion.dart';
import 'package:grocery/views/report/components/report_cognitivetest.dart';
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ReportSummary(summary: report.summary),
                  SizedBox(height: 50),
                  ReportEmotion(emotionRatio: report.emotionRatio),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ReportCognitive(),
            ),
            ReprotButton(),
          ],
        ),
      ),
    );
  }
}
