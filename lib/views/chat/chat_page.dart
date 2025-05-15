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
  bool _isListeningLoading = false;
  bool _isListening = false; // 마이크 활성 상태
  List<String> _messages = [];
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
        // _isListeningLoading = true; // 로딩 인디케이터를 시작합니다
      });
      _speechToText.listen(
        localeId: 'ko_KR',
        onResult: (result) {
          print(
              "📝 인식 중: ${result.recognizedWords} (final: ${result.finalResult})");
          setState(() {
            _controller.text = result.recognizedWords;
          });
          if (result.finalResult) {
            print("최종 결과 반영: ${result.recognizedWords}");
            setState(() {
              _isListening = false;
              _isListeningLoading = false;
              _controller.text = result.recognizedWords;
            });
          }
        },
      );
    } else {
      setState(() {
        _isListening = false;
        _isListeningLoading = false;
      });
    }
  }

  //녹음 중지
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _isListeningLoading = false;
    });
  }

  void _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
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
              padding: const EdgeInsets.all(16.0),
              children: [
                const ChatBubble(
                  message: "오늘 일어났던 일들 중에서 기억에 가장 많이 남는 일은 어떤 것인가요?",
                  isMe: false,
                  time: "9:41",
                ),
                // ..._chatList,
              ],
            ),
          ),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: _isListening ? '말씀해 주세요..' : '메시지를 입력하세요',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.green,
                        size: 36,
                      ),
                      onPressed: _toggleListening,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
