import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils/device_id_manager.dart';

// Report 모델
class Report {
  final String user_uuid;
  final String emoji;
  final String title;
  final String summary;
  final List<Map<String, String>> cognitiveResult;
  final Map<String, double> emotionRatio;
  final String cognitiveAnalysis;
  final String depressionResult;

  Report({
    required this.user_uuid,
    required this.emoji,
    required this.title,
    required this.summary,
    required this.cognitiveResult,
    required this.emotionRatio,
    required this.cognitiveAnalysis,
    required this.depressionResult,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    Map<String, double> emotionMap = {};
    if (json['emotionRatio'] != null) {
      json['emotionRatio'].forEach((key, value) {
        emotionMap[key] = (value as num).toDouble();
      });
    }

    List<Map<String, String>> cognitiveList = [];
    if (json['cognitiveResult'] != null && json['cognitiveResult'] is List) {
      for (var entry in json['cognitiveResult']) {
        cognitiveList.add({
          "question": entry["question"] ?? "",
          "area": entry["area"] ?? "",
          "accuracy": entry["accuracy"] ?? "",
        });
      }
    }

    return Report(
      user_uuid: json['user_uuid'] ?? '',
      emoji: json['emoji'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      cognitiveResult: cognitiveList,
      emotionRatio: emotionMap,
      cognitiveAnalysis: json['cognitiveAnalysis'] ?? '0.0',
      depressionResult: json['depressionResult'] ?? '',
    );
  }
}

// 날짜별 Report를 저장할 DB
final Map<DateTime, Report> reportDB = {};

// 서버에서 받아와 reportDB에 저장
Future<void> fetchAndStoreReports() async {
  final userUuid = (await DeviceIdManager.getDeviceId()).toString();
  // final userUuid = 'uuid-1234';
  final response = await http
      // .get(Uri.parse('http://localhost:3000/dairy?user_uuid=$userUuid'));
      .get(Uri.parse('http://10.20.34.250:3000/dairy?user_uuid=$userUuid'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);

    for (var json in jsonList) {
      final date = DateTime.parse(json['date']);
      final key = DateTime.utc(date.year, date.month, date.day);
      final report = Report.fromJson(json);
      reportDB[key] = report;
    }
  } else {
    throw Exception('Failed to load reports');
  }
}

// 날짜로 Report 조회
Report? getReportByDate(DateTime date) {
  final key = DateTime.utc(date.year, date.month, date.day);
  return reportDB[key];
}
