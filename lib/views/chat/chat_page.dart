import 'package:flutter/material.dart';
import '../chat/components/chat_bubble.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 필드 제어용

  bool _isListening = false; // 마이크 활성 상태

  String _interimText = ""; // 중간 인식 텍스트
  List<Map<String, String>> _messages = []; // {message, time}

  String _currentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  // STT, TTS 객체 생성
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // List<ChatBubble> _chatList = []; // 대화 내역 저장

  Future<void> _startListening() async {
    final microphoneStatus = await Permission.microphone.request();
    final speechStatus = await Permission.speech.request(); // 일부 기기에서 필요

    if (microphoneStatus.isDenied || speechStatus.isDenied) {
      // 사용자가 거절한 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('음성 인식 및 마이크 권한이 필요합니다.')),
      );
      return;
    }

    // STT 초기화
    bool available = await _speechToText.initialize(
      onError: (error) => print('❌ STT 오류: ${error.errorMsg}'),
      onStatus: (status) => print('🎤 상태: $status'),
    );

    if (available) {
      print("✅ STT 사용 가능");
      setState(() {
        print("✅ 녹음상태 on");
        _isListening = true; // 녹음 상태 true
        _interimText = "";
      });
      _speechToText.listen(
        localeId: 'ko_KR',
        onResult: (result) {
          print(
              "📝 인식 중: ${result.recognizedWords} (final: ${result.finalResult})");

          if (!result.finalResult) {
            // 중간 결과는 계속 업데이트
            setState(() {
              _interimText = result.recognizedWords;
            });
          } else {
            // 말이 끝났을 때 메시지 확정
            setState(() {
              _messages.add({
                'message': result.recognizedWords,
                'time': _currentTime(),
              });
              _interimText = ""; // 중간 텍스트 제거
              _isListening = false; // 마이크 상태 OFF
            });
            _speechToText.stop(); // 명시적으로 STT 종료
          }
        },
      );
    } else {
      setState(() {
        _isListening = false;
        _interimText = "";
      });
    }
  }

  //녹음 중지
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _interimText = "";
    });
  }

  String _currentQuestion = "오늘 일어났던 일 중에서 기억에 가장 많이 남는 일은 어떤 것인가요?";

  void _toggleListening() async {
    _isListening ? _stopListening() : _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("5월 2일의 기록"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 기록 완료 액션
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 안내 문구
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              "오늘 일어났던 일에 대해 저와 대화를 하며 기록해주세요.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),

          // 중앙 영역 전체 배경 포함
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 197, 225, 165),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ AI 질문 텍스트
                    GestureDetector(
                      onTap: () {
                        _flutterTts.setLanguage('ko-KR');
                        _flutterTts.setPitch(1.0);
                        _flutterTts.setSpeechRate(0.5);
                        _flutterTts.speak(_currentQuestion);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentQuestion,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF2C2C2C),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ✅ 사용자 확정 메시지 말풍선 형태로
                    ..._messages.map(
                      (msg) => Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          child: Text(
                            msg['message']!,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                    ),

                    // ✅ 실시간 사용자 중간 메시지
                    if (_interimText.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _interimText,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 하단 마이크 버튼
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Center(
              child: FloatingActionButton(
                onPressed: _toggleListening,
                backgroundColor: _isListening ? Colors.red : Colors.green,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
