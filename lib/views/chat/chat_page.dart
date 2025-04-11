import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eGrocery',
      home: Scaffold( // home 속성 추가 (필수)
        appBar: AppBar(
          title: const Text('eGrocery Chat'),
        ),
        body: const Center(
          child: Text('Chat Page Content'),
        ),
      ),
    );
  }
}