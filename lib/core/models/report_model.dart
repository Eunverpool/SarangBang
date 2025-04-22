class Report {
  final String emoji; // 😊
  final String title; // 제목
  final String summary; // 일기

  final String cognitiveResult; // 인지 테스트 결과
  // final List<QuestionResult> cognitiveResults;  <== 변경 예정

  final Map<String, int> emotionRatio; // 감정 분석

  Report({
    required this.emoji,
    required this.title,
    required this.summary,
    required this.cognitiveResult,
    required this.emotionRatio,
  });
}
