// import 'package:flutter/material.dart';
// import '../chat/components/chat_bubble.dart';

// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _controller =
//       TextEditingController(); // 텍스트 입력 필드 제어용

//   bool _isListening = false; // 마이크 활성 상태

//   String _interimText = ""; // 중간 인식 텍스트
//   List<Map<String, String>> _messages = []; // {message, time}

//   String _currentTime() {
//     final now = DateTime.now();
//     return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
//   }

//   // STT, TTS 객체 생성
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();



//   Future<String> _getLlamaResponse(String prompt) async {
//     final url = Uri.parse('https://88d9-34-53-107-134.ngrok-free.app/chat');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         // body: jsonEncode({'input': prompt}),

//         body: jsonEncode({
//           'input': prompt, // 사용자 입력
//           'session_id': 'user1234' // 유저 세션 ID (임시/고정/UUID 등 사용 가능)
//         }),
//       );
//       print('서버 응답: ${response.body}');

//       if (response.statusCode == 200) {
//         final decoded = utf8.decode(response.bodyBytes);

//         final json = jsonDecode(decoded);
//         print('응답txt: ${json['response']}');
//         return json['response'] ?? '응답이 없습니다.';
//       } else {
//         return '서버 오류: ${response.statusCode}';
//       }
//     } catch (e) {
//       return '오류 발생: $e';
//     }
//   }

//   Future<void> _startListening() async {
//     final microphoneStatus = await Permission.microphone.request();
//     final speechStatus = await Permission.speech.request();

//     if (microphoneStatus.isDenied || speechStatus.isDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('음성 인식 및 마이크 권한이 필요합니다.')),
//       );
//       return;
//     }

//     bool available = await _speechToText.initialize(
//       onError: (error) => print('❌ STT 오류: ${error.errorMsg}'),
//       onStatus: (status) => print('🎤 상태: $status'),
//     );

//     if (available) {
//       print("✅ STT 사용 가능");
//       setState(() {
//         _isListening = true;
//         _interimText = "";
//       });

//       _speechToText.listen(
//         localeId: 'ko_KR',
//         onResult: (result) async {
//           print(
//               "📝 인식 중: ${result.recognizedWords} (final: ${result.finalResult})");

//           if (!result.finalResult) {
//             setState(() {
//               _interimText = result.recognizedWords;
//             });
//           } else {
//             final userText = result.recognizedWords;

//             setState(() {
//               _messages.add({
//                 'message': userText,
//                 'time': _currentTime(),
//                 'isMe': 'true'
//               });
//               _interimText = "";
//               _isListening = false;
//             });

//             _speechToText.stop();

//             // ✅ LLaMA API 연동
//             final llamaResponse = await _getLlamaResponse(userText);

//             // ✅ LLaMA 응답 저장 및 TTS 재생
//             setState(() {
//               _messages.add({
//                 'message': llamaResponse,
//                 'time': _currentTime(),
//                 'isMe': 'false'
//               });
//             });

//             _flutterTts.setLanguage('ko-KR');
//             _flutterTts.setPitch(1.0);
//             _flutterTts.setSpeechRate(0.5);
//             await _flutterTts.speak(llamaResponse);
//           }
//         },
//       );
//     } else {
//       setState(() {
//         _isListening = false;
//         _interimText = "";
//       });
//     }
//   }

//   //녹음 중지
//   void _stopListening() {
//     _speechToText.stop();
//     setState(() {
//       _isListening = false;
//       _interimText = "";
//     });
//   }

//   String _currentQuestion = "오늘 일어났던 일 중에서 기억에 가장 많이 남는 일은 어떤 것인가요?";

//   void _toggleListening() async {
//     _isListening ? _stopListening() : _startListening();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("5월 2일의 기록"),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         foregroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: () {
//               // 기록 완료 액션
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 상단 안내 문구
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             child: Text(
//               "오늘 일어났던 일에 대해 저와 대화를 하며 기록해주세요.",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//           ),

//           // 중앙 영역 전체 배경 포함
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               color: const Color.fromARGB(255, 197, 225, 165),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               child: SingleChildScrollView(
//                 reverse: true,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // ✅ AI 질문 텍스트
//                     GestureDetector(
//                       onTap: () {
//                         _flutterTts.setLanguage('ko-KR');
//                         _flutterTts.setPitch(1.0);
//                         _flutterTts.setSpeechRate(0.5);
//                         _flutterTts.speak(_currentQuestion);
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.indigo[100],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           _currentQuestion,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             color: Color(0xFF2C2C2C),
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     ..._messages.map(
//                       (msg) => Align(
//                         alignment: msg['isMe'] == 'false'
//                             ? Alignment.centerLeft
//                             : Alignment.centerRight,
//                         child: GestureDetector(
//                           // ✅ 클릭 이벤트 추가
//                           onTap: msg['isMe'] == 'false'
//                               ? () {
//                                   _flutterTts.setLanguage('ko-KR');
//                                   _flutterTts.setPitch(1.0);
//                                   _flutterTts.setSpeechRate(0.5);
//                                   _flutterTts
//                                       .speak(msg['message']!); // AI 응답 읽기
//                                 }
//                               : null, // 사용자는 클릭해도 아무 동작 없음

//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 6),
//                             padding: const EdgeInsets.all(12),
//                             constraints: const BoxConstraints(maxWidth: 300),
//                             decoration: BoxDecoration(
//                               color: msg['isMe'] == 'false'
//                                   ? Colors.indigo[100]
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   offset: Offset(2, 2),
//                                 )
//                               ],
//                             ),
//                             child: Text(
//                               msg['message']!,
//                               style: TextStyle(
//                                 //     fontSize: 20,
//                                 // color: Color(0xFF2C2C2C),
//                                 // height: 1.5,
//                                 height: msg['isMe'] == 'false' ? 1.5 : 1,
//                                 fontSize: msg['isMe'] == 'false' ? 20 : 16,
//                                 color: msg['isMe'] == 'false'
//                                     ? Color(0xFF2C2C2C)
//                                     : Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // ✅ 실시간 사용자 중간 메시지
//                     if (_interimText.isNotEmpty)
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(12),
//                           constraints: const BoxConstraints(maxWidth: 300),
//                           decoration: BoxDecoration(
//                             color: Colors.white70,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             _interimText,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.black54),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // 하단 마이크 버튼
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               border: const Border(top: BorderSide(color: Colors.grey)),
//             ),
//             child: Center(
//               child: FloatingActionButton(
//                 onPressed: _toggleListening,
//                 backgroundColor: _isListening ? Colors.red : Colors.green,
//                 child: Icon(
//                   _isListening ? Icons.mic : Icons.mic_none,
//                   size: 32,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
