import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/diary_data.dart';

class DiaryCalendar extends StatefulWidget {
  const DiaryCalendar({super.key});

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  // 현재 보고 있는 날짜
  DateTime _focusedDay = DateTime.now();

  // 유저가 선택한 날짜 (터치 시 변경)
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        /// 📅 감정 이모지가 적용된 커스터마이징 캘린더
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),     // 시작 날짜
          lastDay: DateTime.utc(2030, 12, 31),    // 종료 날짜
          locale: 'ko-KR',                        // 한글 로케일 설정
          focusedDay: _focusedDay,                // 현재 보여주는 월 기준 날짜

          // 선택된 날짜인지 여부 체크
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

          // 날짜 클릭 시 선택 상태 갱신
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          
          /// 캘린더 헤더 스타일 (연/월만 중앙 정렬)
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: true,
            rightChevronVisible: true,
          ),

          /// 기본 날짜 스타일 지정
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 1.5),
            ),
            todayTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          /// 날짜 셀 커스터마이징 (이모지 표시)
          calendarBuilders: CalendarBuilders(
            // 일반 날짜
            defaultBuilder: (context, day, _) {
              final emoji = emotionEmoji[DateTime.utc(day.year, day.month, day.day)];
              if (emoji != null) {
                return Center(child: Text(emoji, style: const TextStyle(fontSize: 20)));
              }
              return null; // 기본 숫자 표시
            },

            // 오늘 날짜
            todayBuilder: (context, day, _) {
              final emoji = emotionEmoji[DateTime.utc(day.year, day.month, day.day)];
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji ?? '${day.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              );
            },

            // 선택된 날짜
            selectedBuilder: (context, day, _) {
              final emoji = emotionEmoji[DateTime.utc(day.year, day.month, day.day)];
              return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji ?? '${day.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              );
            },
          ),
        ), // TableCalendar

        const SizedBox(height: 20),

        /// 📌 선택된 날짜의 일기 요약 표시 (제목 한 줄)
        if (_selectedDay != null &&
            diarySummary.containsKey(DateTime.utc(
              _selectedDay!.year,
              _selectedDay!.month,
              _selectedDay!.day,
            )))
          GestureDetector(
            onTap: () {
              // 일일 보고서 페이지 연결 (현재는 스낵바로 대체)
              final summary = diarySummary[DateTime.utc(
                _selectedDay!.year,
                _selectedDay!.month,
                _selectedDay!.day,
              )];
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('일일보고서 보기: $summary')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                diarySummary[DateTime.utc(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                )]!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
    
  }
}
