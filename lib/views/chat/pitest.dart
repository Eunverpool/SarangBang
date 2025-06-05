// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;

// class pi extends StatefulWidget {
//   const pi({super.key});

//   @override
//   State<pi> createState() => _PiState();
// }

// class _PiState extends State<pi> {
//   String _signal = '신호 대기 중...';

//   @override
//   void initState() {
//     super.initState();
//     _startHttpServer();
//   }

//   void _startHttpServer() async {
//     final handler = Pipeline().addHandler((Request request) async {
//       if (request.method == 'POST' && request.url.path == 'receive') {
//         final body = await request.readAsString();
//         final data = jsonDecode(body);
//         final signal = data['signal'];

//         setState(() {
//           _signal = '받은 신호: $signal';
//         });

//         print('🔔 신호 수신: $signal');

//         return Response.ok('신호 수신 완료');
//       }
//       return Response.notFound('Not Found');
//     });

//     final server = await shelf_io.serve(
//       handler,
//       InternetAddress.anyIPv4,
//       8080,
//     );

//     print('✅ Flutter 서버 실행 중: http://${server.address.address}:${server.port}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('라즈베리파이 테스트 수신기')),
//       body: Center(
//         child: Text(
//           _signal,
//           style: const TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
