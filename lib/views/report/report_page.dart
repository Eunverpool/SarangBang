import 'package:flutter/material.dart';
import 'package:grocery/views/report/components/report_Header.dart';
import 'package:grocery/views/report/components/report_content.dart';
import 'package:grocery/views/report/components/report_button.dart';

import '../../core/constants/constants.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReportHeader(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ReportContent(),
      ),
    );
  }
}
