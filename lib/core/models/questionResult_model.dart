class QuestionResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String category; // 예: '기억력', '주의력', '언어이해'

  QuestionResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.category,
  });
}
