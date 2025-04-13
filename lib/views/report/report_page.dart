import 'package:flutter/material.dart';
import 'package:grocery/views/report/components/report_Header.dart';
import 'package:grocery/views/report/components/report_content.dart';
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
            ReportSummary(),
            SizedBox(height: 20),
            ReportEmotion(),
            SizedBox(height: 20),
            reportCognitive(),
            Spacer(),
            ReprotButton(),
          ],
        ),
      ),
    );
  }
}
