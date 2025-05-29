import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class chat2 extends StatefulWidget {
  const chat2({Key? key}) : super(key: key);

  @override
  State<chat2> createState() => _chat2State();
}

class _chat2State extends State<chat2> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> sendQuestionToColab(String inputText) async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://b42f-35-223-9-116.ngrok-free.app/chat'), // 추후 ngrok 주소로 교체
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"input": inputText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _response = data['response'] ?? '응답 없음';
        });
      } else {
        setState(() {
          _response = '서버 오류: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = '통신 오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Colab 챗봇 테스트'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CupertinoTextField(
                controller: _controller,
                placeholder: '질문을 입력하세요',
              ),
              const SizedBox(height: 12),
              CupertinoButton.filled(
                child: _isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('전송'),
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_controller.text.trim().isNotEmpty) {
                          sendQuestionToColab(_controller.text.trim());
                        }
                      },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_response),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
