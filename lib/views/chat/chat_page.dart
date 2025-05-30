import 'package:flutter/material.dart';
import '../chat/components/chat_bubble.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// 기기 ID 관리
import '/utils/device_id_manager.dart';
import 'package:intl/intl.dart';

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
    final now = DateTime.now().toLocal();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  // STT, TTS 객체 생성
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // UUID 변수
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final id = await DeviceIdManager.getOrCreateDeviceId();
    setState(() {
      _deviceId = id;
    });
  }

// GPT
  Future<String> _getGptResponse(String prompt) async {
    final url = Uri.parse('http://localhost:3000/gpt');
    try {
      print("탕야지 GPT API 요청 전송 시작");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_uuid': _deviceId, // <-- 디바이스 UUID 추가
          'input': prompt, // 사용자 입력
        }),
      );
      print("잘 받와야지 GPT 응답 statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ GPT 응답 : ${decoded['response']}");
        return decoded['response'] ?? '응답 없음';
      } else {
        print("❌ GPT 서버 응답 에러: ${response.statusCode}");
        return '서버 오류';
      }
    } catch (e) {
      print("❌ GPT 호출 실패: $e");
      return '오류 발생';
    }
  }

  Future<void> saveChatToServer(
      String uuId, String userMsg, String botMsg) async {
    final saveUrl = Uri.parse("http://localhost:3000/chat");

    try {
      final response = await http.post(
        saveUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_uuid': uuId,
          'chat_date': DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.now().toLocal()),
          'messages': [
            {'role': 'user', 'content': userMsg},
            {'role': 'assistant', 'content': botMsg}
          ],
        }),
      );
      print("💾 Chat 저장 응답: ${response.body}");
    } catch (e) {
      print("❌ Chat 저장 오류: $e");
    }
  }

  Future<void> _startListening() async {
    final microphoneStatus = await Permission.microphone.request();
    final speechStatus = await Permission.speech.request();

    if (microphoneStatus.isDenied || speechStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('음성 인식 및 마이크 권한이 필요합니다.')),
      );
      return;
    }

    bool available = await _speechToText.initialize(
      onError: (error) => print('❌ STT 오류: ${error.errorMsg}'),
      onStatus: (status) => print('🎤 상태: $status'),
    );

    if (available) {
      print("✅ STT 사용 가능");
      setState(() {
        _isListening = true;
        _interimText = "";
      });

      _speechToText.listen(
        localeId: 'ko_KR',
        onResult: (result) async {
          print(
              "📝 인식 중: ${result.recognizedWords} (final: ${result.finalResult})");

          if (!result.finalResult) {
            setState(() {
              _interimText = result.recognizedWords;
            });
          } else {
            final userText = result.recognizedWords;

            setState(() {
              _messages.add({
                'message': userText,
                'time': _currentTime(),
                'isMe': 'true'
              });
              _interimText = "";
              _isListening = false;
            });

            _speechToText.stop();

            // ✅ GPT API 연동
            final gptResponse = await _getGptResponse(userText);
            // ✅ MongoDB에 대화 저장하기
            // if (_deviceId != null) {
            //   await saveChatToServer(_deviceId!, userText, gptResponse);
            // } else {
            //   print("❗ 디바이스 ID가 아직 초기화되지 않았습니다.");
            // }

            // ✅ GPT 응답 저장 및 TTS 재생
            setState(() {
              _messages.add({
                'message': gptResponse,
                'time': _currentTime(),
                'isMe': 'false'
              });
            });

            _flutterTts.setLanguage('ko-KR');
            _flutterTts.setPitch(1.0);
            _flutterTts.setSpeechRate(0.5);
            await _flutterTts.speak(gptResponse);
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

  String _currentQuestion = "오늘은 어떤 일이 있으셨나요? 당신의 하루 이야기를 들려주세요.";

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
              onPressed: () async {
                if (_deviceId == null) return;

                final url = Uri.parse("http://localhost:3000/dairy");
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'user_uuid': _deviceId}),
                );

                final decoded = jsonDecode(utf8.decode(response.bodyBytes));
                if (decoded['alreadyExists'] == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("알림"),
                      content: const Text(
                          "오늘의 일기는 이미 작성되었습니다.\n이후 대화는 일기에 반영되지 않습니다."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("확인"),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ 오늘의 일기가 저장되었습니다.")),
                  );
                }
              }),
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
              color: const Color(0xFFFFFBF7),
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

                    ..._messages.map(
                      (msg) => Align(
                        alignment: msg['isMe'] == 'false'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: GestureDetector(
                          // ✅ 클릭 이벤트 추가
                          onTap: msg['isMe'] == 'false'
                              ? () {
                                  _flutterTts.setLanguage('ko-KR');
                                  _flutterTts.setPitch(1.0);
                                  _flutterTts.setSpeechRate(0.5);
                                  _flutterTts
                                      .speak(msg['message']!); // AI 응답 읽기
                                }
                              : null, // 사용자는 클릭해도 아무 동작 없음

                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              color: msg['isMe'] == 'false'
                                  ? Colors.indigo[100]
                                  : Colors.white,
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
                              style: TextStyle(
                                //     fontSize: 20,
                                // color: Color(0xFF2C2C2C),
                                // height: 1.5,
                                height: msg['isMe'] == 'false' ? 1.5 : 1,
                                fontSize: msg['isMe'] == 'false' ? 20 : 16,
                                color: msg['isMe'] == 'false'
                                    ? Color(0xFF2C2C2C)
                                    : Colors.black87,
                              ),
                            ),
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
              color: const Color.fromARGB(255, 255, 255, 255),
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
