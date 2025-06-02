import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Colab2 extends StatefulWidget {
  const Colab2({Key? key}) : super(key: key);

  @override
  State<Colab2> createState() => _Colab2State();
}

class _Colab2State extends State<Colab2> {
  String resultText = '분석 결과가 여기에 표시됩니다.';
  bool isLoading = false;

  Future<void> sendWavToServer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result == null) return;

    setState(() {
      isLoading = true;
      resultText = '분석 중...';
    });

    File file = File(result.files.single.path!);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://7ed7-34-73-212-106.ngrok-free.app/predict'),
    );

    request.files.add(await http.MultipartFile.fromPath('audio', file.path));



    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var body = await response.stream.bytesToString();
        var decoded = jsonDecode(body);
        setState(() {
          resultText = 
            "🧠 치매 예측: ${decoded['dementia']} (확률: ${(decoded['dementia_prob'] * 100).toStringAsFixed(1)}%)\n"
            "😔 우울 예측: ${decoded['depression']} (확률: ${(decoded['depression_prob'] * 100).toStringAsFixed(1)}%)";
        });
      } else {
        setState(() {
          resultText = "❌ 서버 오류 발생: 상태코드 ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        resultText = "❌ 통신 오류: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Colab 치매 + 우울 예측"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : sendWavToServer,
              child: const Text("WAV 파일 선택 및 예측"),
            ),
            const SizedBox(height: 30),
            Text(
              resultText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
