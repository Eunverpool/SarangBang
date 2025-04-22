import 'package:grocery/core/models/report_model.dart';

final Map<DateTime, Report> reportDB = {
  DateTime.utc(2025, 4, 10): Report(
    emoji: '😊',
    title: '산책하며 기분 좋았던 하루',
    summary: '오늘은 날씨가 정말 맑고 따뜻해서 아침에 동네 공원을 산책했어요. '
        '벚꽃이 피어 있는 길을 따라 걷다 보니 기분이 절로 좋아졌습니다. '
        '산책 후에는 따뜻한 커피를 마시며 책을 읽었고, 하루 종일 평화롭고 안정된 기분을 느꼈어요. '
        '이런 날이 자주 있었으면 좋겠다는 생각이 들었습니다.',
    cognitiveResult: '날짜 인식: 정확 / 최근 식사 회상: 정확 / 기억력 회상: 약간 부정확',
    emotionRatio: {
      '행복': 60,
      '평온': 30,
      '불안': 10,
    },
  ),
  DateTime.utc(2025, 4, 12): Report(
    emoji: '😢',
    title: '외롭고 우울했던 하루',
    summary: '오늘은 혼자 있는 시간이 많았고, 친구들에게 연락이 닿지 않아 외로움을 많이 느꼈어요. '
        '집 안에만 있다 보니 우울한 생각이 자꾸 들어서 좋아하는 음악을 틀어놓고 분위기를 바꾸려 했지만, '
        '마음이 쉽게 나아지지 않았습니다. 내일은 꼭 바깥 공기를 쐬며 기분 전환을 해야겠어요.',
    cognitiveResult: '날짜 인식: 정확 / 최근 식사 회상: 부정확 / 기억력 회상: 부정확',
    emotionRatio: {
      '슬픔': 50,
      '무기력': 30,
      '불안': 20,
    },
  ),
  DateTime.utc(2025, 4, 14): Report(
    emoji: '😠',
    title: '일이 꼬여서 스트레스 받음',
    summary: '하루 종일 계획대로 되는 일이 하나도 없었어요. 아침에 스마트폰 알람이 울리지 않아 지각했고, '
        '회의 시간도 착각해서 중요한 발표를 놓쳤습니다. 오후에는 컴퓨터도 오류가 나서 문서 작업을 날려버렸고, '
        '정말 최악의 하루였어요. 스트레스를 좀 해소하려고 운동을 했지만 마음이 진정되지 않았어요.',
    cognitiveResult: '날짜 인식: 정확 / 최근 식사 회상: 정확 / 기억력 회상: 정확',
    emotionRatio: {
      '분노': 50,
      '불안': 30,
      '긴장': 20,
    },
  ),
  DateTime.utc(2025, 4, 15): Report(
    emoji: '🎂',
    title: '생일 파티로 행복한 하루!',
    summary: '오늘은 제 생일이었어요! 가족과 친구들이 깜짝 파티를 열어줘서 정말 감동받았어요. '
        '맛있는 케이크와 선물, 함께한 웃음들이 하루 종일 이어졌고, '
        '나를 위해 이렇게 마음 써주는 사람들이 있다는 게 참 감사하게 느껴졌어요. '
        '잊지 못할 생일이었고, 마음 한가득 행복으로 채워진 하루였어요.',
    cognitiveResult: '날짜 인식: 정확 / 최근 식사 회상: 정확 / 기억력 회상: 정확',
    emotionRatio: {
      '행복': 70,
      '감사': 20,
      '설렘': 10,
    },
  ),
};

Report? getReportByDate(DateTime date) {
  final key = DateTime.utc(date.year, date.month, date.day);
  return reportDB[key];
}
