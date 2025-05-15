import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: isMe ? 240 : double.infinity, // 사용자: 작게, AI: 전체 폭
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.lightGreen[200] // 사용자 말풍선 색
                  : Colors.green[400], // AI 말풍선 색 (진한 연두색)
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: isMe ? 14 : 20,
                color: isMe ? Colors.black : Colors.white,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
            child: Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
