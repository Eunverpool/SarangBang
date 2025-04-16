import 'package:flutter/material.dart';
import 'package:grocery/views/report/components/report_header.dart';
import 'package:grocery/views/report/components/report_button.dart';
import 'package:grocery/views/report/components/report_summary.dart';
import 'package:grocery/views/report/components/report_emotion.dart';
import 'package:grocery/views/report/components/report_cognitivetest.dart';
import '../../core/constants/constants.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ReportHeader(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ReportSummary(),
                  SizedBox(height: 50),
                  ReportEmotion(),
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
