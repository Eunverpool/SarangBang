import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              children: const [
                ChatBubble(
                  message: "오늘 일어났던 일들 중에서 가장 많이 남는 어떤 것인가요?",
                  isMe: false,
                  time: "9:41",
                ),
                ChatBubble(
                  message: "건강이 가장 중요하니까 걱정돼요. 감기에 걸려서 병원에 갔어.",
                  isMe: true,
                  time: "9:42",
                ),
                ChatBubble(
                  message:
                      "저런, 감기에 걸리셨군요.\n물과 소금을 충분히 섭취하고\n휴식을 취하는 것이 중요해요.\n복용 지침을 잘 따르고 병원에서 받은 조언을 따르세요.\n회복되기를 바라요.\n어떻게 지내고 있는지 계속 알려주실래요?",
                  isMe: false,
                  time: "9:43",
                ),
                ChatBubble(
                  message: "걱정해줘서 고마워. 병원에 간 뒤에는 집에 누워서 폭 쉬었어.",
                  isMe: true,
                  time: "9:45",
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.mic, color: Colors.red, size: 56),
                onPressed: () {
                  // 음성 녹음 기능 구현
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatBubble({
    required this.message,
    required this.isMe,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
