import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 진동에 필요

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final VoidCallback? onTap;

  const ChatBubble({
    required this.message,
    required this.isMe,
    required this.time,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isMe
          ? null
          : () {
              HapticFeedback.lightImpact(); // 💡 진동 추가
              onTap?.call();
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: isMe ? 240 : double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isMe ? Colors.lightGreen[200] : Colors.green[400],
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
      ),
    );
  }
}
