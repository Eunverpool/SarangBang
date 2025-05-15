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

  void _toggleListening() async {
    _isListening ? _stopListening() : _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text('5월 2일의 기록'),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ✅ 첫 AI 말풍선 고정
                ChatBubble(
                  //LLaMA API에서 받아온 응답을 _aiMessages 리스트에 추가하면서:

                  // _aiMessages.add({
                  //   'message': llamaResponse,
                  //   'time': _currentTime(),
                  // });

                  // _flutterTts.speak(llamaResponse); // 자동 읽기
                  // 그리고 ChatBubble에서 그 메시지를 클릭하면 다시 들을 수 있게 유지
                  message: "오늘 일어났던 일 중 가장 기억에 남는 일은 무엇인가요?",
                  isMe: false,
                  time: "오전 9:00",
                  onTap: () {
                    _flutterTts.setLanguage('ko-KR');
                    _flutterTts.setPitch(1.0);
                    _flutterTts.setSpeechRate(0.5);
                    _flutterTts.speak("오늘 일어났던 일 중 가장 기억에 남는 일은 무엇인가요?");
                  },
                ),

                // ✅ 확정된 사용자 메시지 출력
                ..._messages.map(
                  (msg) => ChatBubble(
                    message: msg['message']!,
                    time: msg['time']!,
                    isMe: true,
                  ),
                ),

                // ✅ 실시간 중간 인식 메시지
                if (_interimText.isNotEmpty)
                  ChatBubble(
                    message: _interimText,
                    time: _currentTime(),
                    isMe: true,
                  ),
              ],
            ),
          ),

          // ✅ 하단 마이크 버튼 UI
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
