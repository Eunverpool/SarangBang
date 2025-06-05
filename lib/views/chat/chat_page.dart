import 'package:flutter/material.dart';
import '../chat/components/chat_bubble.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
// 녹음
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  // 녹음 변수
  final AudioRecorder _recorder = AudioRecorder();
  String? _recordFilePath;

  bool _isCognitiveMode = false; //인지 질문 여부
  bool _isRecording = false; // 녹음 진행 여부

  // 저장여부 변수
  bool _isAwaitingDiarySave = false;

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
    final url = Uri.parse('http://10.20.27.96:3000/gpt');
    try {
      print("GPT API 요청 전송 시작");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_uuid': _deviceId, // <-- 디바이스 UUID 추가
          'input': prompt, // 사용자 입력
        }),
      );
      print("GPT 응답 statusCode: ${response.statusCode}");
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

// 녹음 시작 함수
  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      print('❌ 마이크 권한 거부됨');
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        '${dir.path}/${_deviceId}_cognitive_${DateTime.now().millisecondsSinceEpoch}.wav';

    // ✅ 1. 녹음 시작
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000, // 안정적인 측정을 위해 설정
        numChannels: 1,
      ),
      path: filePath,
    );

    setState(() {
      _recordFilePath = filePath;
      _isRecording = true;
    });

    print('🎙️ 녹음 시작: $filePath');

    // ✅ 2. 무음 감지 시작
    int silenceCount = 0;

    _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) async {
      if (amp != null && amp.current != null) {
        print('🎧 데시벨: ${amp.current}');
        if (amp.current <= -20) {
          silenceCount++;
          if (silenceCount * 300 >= 2000) {
            print('🤫 3초 이상 무음 감지 → 녹음 종료');
            await _stopRecording();
            setState(() {
              _isRecording = false;
              _isCognitiveMode = false;
            });
          }
        } else {
          silenceCount = 0; // 소리 있음
        }
      } else {
        print('⚠️ amplitude null 또는 측정 안 됨');
      }
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    print('✅ 녹음 완료: $path');
    if (path != null) {
      // Whisper에 텍스트 요청
      final whisperText = await sendWavToWhisper(path);
      if (whisperText != null && whisperText.isNotEmpty) {
        // GPT 대화 흐름 연결
        setState(() {
          _messages.add({
            'message': whisperText,
            'time': _currentTime(),
            'isMe': 'true',
          });
        });

        final gptResponse = await _getGptResponse(whisperText);

        setState(() {
          _messages.add({
            'message': gptResponse,
            'time': _currentTime(),
            'isMe': 'false',
          });
        });

        sendWavFile(path); // 🔁 여기서 모델에게 wav 파일 전송

        _flutterTts.setLanguage('ko-KR');
        _flutterTts.setPitch(1.0);
        _flutterTts.setSpeechRate(0.5);
        await _flutterTts.speak(gptResponse);

        // ✅ [저장] 태그 탐지 추가'
        if (gptResponse.contains("[저장]")) {
          _flutterTts.setCompletionHandler(() {
            setState(() {
              _isAwaitingDiarySave = true;
            });
            print("💾 [녹음 후] 저장 유도 탐지됨");
            _startListening(); // TTS 끝나고 STT 재시작
          });
        }
      } else {
        print("❗ Whisper로부터 텍스트를 받지 못함");
      }
    } else {
      print('❌ 녹음 파일 경로가 null입니다.');
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> sendWavFile(String filePath) async {
    final uri = Uri.parse('https://bd9e-35-204-222-22.ngrok-free.app/predict');
    final file = File(filePath);

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('audio', file.path));

    try {
      final response = await request.send();
      final result = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('✅ 모델 응답: $result');
        final jsonResult = jsonDecode(result);

        // 원본 값
        final dementiaRaw = jsonResult['dementia']; // "Positive" 또는 "Negative"
        final depressionRaw =
            jsonResult['depression']; // e.g., "Depressed" 또는 "Normal"

        print('🧠 치매 분석 결과: $dementiaRaw');
        print('😔 우울 분석 결과: $depressionRaw');

        // 한글 텍스트로 변환
        final String dementiaResult = (dementiaRaw == "Positive") ? "의심" : "정상";
        final String depressionResult =
            (depressionRaw == "Depressed") ? "의심" : "정상";

        print('🧠 치매 분석 결과: $dementiaResult');
        print('😔 우울 분석 결과: $depressionResult');

        // 응답 결과 파싱해서 MongoDB 저장 등 처리
        await sendAnalysisToServer(
            _deviceId ?? "unknown", dementiaResult, depressionResult);
      } else {
        print('❌ 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 오류 발생: $e');
    }
  }

  Future<void> sendAnalysisToServer(
      String uuid, String dementia, String depression) async {
    print("📡 서버에 분석 결과 전송 중...");
    final uri = Uri.parse('http://10.20.27.96:3000/dairy/analysis');
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_uuid": uuid,
        "dementiaResult": dementia,
        "depressionResult": depression,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ 저장 성공: ${response.body}");
    } else {
      print("❌ 저장 실패: ${response.body}");
    }
  }

  Future<String?> sendWavToWhisper(String path) async {
    final uri = Uri.parse("https://181b-34-125-236-97.ngrok-free.app/stt");
    final file = File(path);

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('audio', file.path));

    try {
      final response = await request.send();
      final result = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(result);
        return decoded['text'];
      } else {
        print("❌ Whisper 응답 오류: $result");
        return null;
      }
    } catch (e) {
      print("❌ Whisper 요청 실패: $e");
      return null;
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
        pauseFor: const Duration(seconds: 2),
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

            // 사용자의 저장 요구 감지
            if (_isAwaitingDiarySave &&
                (userText.contains("응") ||
                    userText.contains("저장해") ||
                    userText.contains("그래"))) {
              _isAwaitingDiarySave = false;
              await saveDiary();
              return; // GPT 응답은 생략
            }

            // ✅ GPT API 연동
            final gptResponse = await _getGptResponse(userText);

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

            if (gptResponse.contains("[인지]")) {
              setState(() {
                _isCognitiveMode = true;
              });
              print("🧠 인지 질문 탐지됨. 다음 입력은 녹음 모드.");
            }
            if (gptResponse.contains("[저장]")) {
              setState(() {
                _isAwaitingDiarySave = true;
              });
              print("💾 저장 유도 탐지됨. 다음 입력이 저장 여부 판단에 사용됩니다.");
            }
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

  //STT 중지
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _interimText = "";
    });
  }

  String _currentQuestion = "오늘은 어떤 일이 있으셨나요? 당신의 하루 이야기를 들려주세요.";

  void _toggleListening() async {
    // _isListening ? _stopListening() : _startListening();
    if (_isCognitiveMode) {
      //  인지 모드에서는 마이크 버튼이 녹음으로 동작
      if (_isRecording) {
        await _stopRecording();
        setState(() {
          _isRecording = false;
          _isCognitiveMode = false; //녹음 종료시 인지 모드 해제
        });
      } else {
        // 🔥 상태 먼저 업데이트해서 버튼 색 먼저 바뀌도록
        setState(() {
          _isRecording = true;
        });
        await _startRecording();
      }
    } else {
      _isListening ? _stopListening() : _startListening();
    }
  }

  Future<void> saveDiary() async {
    if (_deviceId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text("일기를 저장 중입니다...")),
          ],
        ),
      ),
    );

    final url = Uri.parse("http://10.20.27.96:3000/dairy");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_uuid': _deviceId}),
    );

    Navigator.of(context).pop();

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded['alreadyExists'] == true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("알림"),
          content: const Text("오늘의 일기는 이미 작성되었습니다.\n이후 대화는 일기에 반영되지 않습니다."),
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
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat("M월 d일").format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$formattedDate의 기록"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                await saveDiary();
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
                backgroundColor:
                    (_isCognitiveMode && _isRecording) || _isListening
                        ? Colors.red
                        : Colors.green,
                child: Icon(
                  _isCognitiveMode && _isRecording ? Icons.mic : Icons.mic_none,
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
