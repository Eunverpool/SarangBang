import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/report_data.dart';

//grocery는 내 프로젝트 이름, pubspec.yaml 파일에서 찾아볼 수 있음
import 'package:grocery/core/routes/app_routes.dart';

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

  void _showYearMonthPicker(BuildContext context) async {
    int selectedYearIndex = _focusedDay.year - 2020;
    int selectedMonthIndex = _focusedDay.month - 1;

    final yearController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    final monthController =
        FixedExtentScrollController(initialItem: selectedMonthIndex);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("월 선택"),
              content: SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        /// 연도 휠
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: yearController, // 초기 위치 지정
                            itemExtent: 40,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                selectedYearIndex = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 20,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    '${2020 + index}년',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        /// 월 휠
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: monthController, //초기 위치 지정
                            itemExtent: 40,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                selectedMonthIndex = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 12,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    '${index + 1}월',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// ✅ 가운데 선택 강조 가이드 박스 (연한 배경)
                    Positioned(
                      top: 80, // (200 - 40) / 2
                      left: 0,
                      right: 0,
                      height: 40,
                      child: IgnorePointer(
                        child: Container(
                          color: Colors.lightGreen[100]!
                              .withAlpha((255 * 0.5).round()), // 연두색 강조
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    final year = 2020 + selectedYearIndex;
                    final month = selectedMonthIndex + 1;
                    setState(() {
                      _focusedDay = DateTime(year, month);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// ✅ 리팩토링된 부분: emoji UI 렌더링 공통 함수
  Widget _buildEmojiDay(int day, String? emoji,
      {bool selected = false, bool today = false}) {
    final textColor = selected
        ? Colors.white
        : today
            ? Colors.grey
            : Colors.black;
    final bgColor = selected ? Colors.green : Colors.transparent;
    final border = today
        ? Border.all(color: Colors.green, width: 1.5)
        : Border.all(color: Colors.transparent);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: border,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
          ),
          const SizedBox(height: 2),
          Text(emoji ?? '', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedKey = _selectedDay != null
        ? DateTime.utc(
            _selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
        : null;
    final selectedReport = selectedKey != null ? reportDB[selectedKey] : null;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            GestureDetector(
              onTap: () => _showYearMonthPicker(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Text(
                  '${_focusedDay.year}년 ${_focusedDay.month}월',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
            ),
          ],
        ),

        /// 📅 감정 이모지가 적용된 커스터마이징 캘린더
        TableCalendar(
          headerVisible: false, //기본 헤더 제거(년 월)
          firstDay: DateTime.utc(2020, 1, 1), // 시작 날짜
          lastDay: DateTime.utc(2039, 12, 31), // 종료 날짜
          locale: 'ko-KR', // 한글 로케일 설정
          focusedDay: _focusedDay, // 현재 보여주는 월 기준 날짜

          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 14, // ✅ 크기 조정
              height: 1, // ✅ 줄 높이 추가
            ),
            weekendStyle: TextStyle(
              fontSize: 14,
              height: 1,
              color: Colors.red, // 일요일 색 강조 (선택)
            ),
          ),
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
              final report =
                  reportDB[DateTime.utc(day.year, day.month, day.day)];
              return _buildEmojiDay(day.day, report?.emoji);
            },

            // 오늘 날짜
            todayBuilder: (context, day, _) {
              final report =
                  reportDB[DateTime.utc(day.year, day.month, day.day)];
              return _buildEmojiDay(day.day, report?.emoji, today: true);
            },

            // 선택된 날짜
            selectedBuilder: (context, day, _) {
              final report =
                  reportDB[DateTime.utc(day.year, day.month, day.day)];
              return _buildEmojiDay(day.day, report?.emoji, selected: true);
            },
          ),
        ),

        const SizedBox(height: 20),

        /// 📌 선택된 날짜의 일기 요약 표시 (제목 한 줄)
        // if (_selectedDay != null && selectedReport != null)
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(
        //         context,
        //         AppRoutes.reportPage,
        //         arguments: _selectedDay,
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(12.0),
        //       child: Text(
        //         '${selectedReport.emoji} ${selectedReport.title}',
        //         style:
        //             const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //   ),
        ...(_selectedDay != null && selectedReport != null
            ? [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reportPage,
                      arguments: _selectedDay,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '${selectedReport.emoji} ${selectedReport.title}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ]
            : []),
      ],
    );
  }
}
