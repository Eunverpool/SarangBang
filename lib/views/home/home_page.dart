import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../chat/chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '사랑방',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/sarangbang_main_img.png',
              fit: BoxFit.cover,
              height: 160,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 24),
          _buildCardItem(context, Icons.person, "보호자 등록하기"),
          const SizedBox(height: 12),
          _buildCardItem(context, Icons.chat, "대화하기", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()));
          }),
          const SizedBox(height: 12),
          _buildCardItem(context, Icons.auto_stories, "어제의 일기"),
          const SizedBox(height: 24),
          const Text("오늘의 일정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActivityItem("오전", "치과 예약", "11:30"),
          const SizedBox(height: 8),
          _buildActivityItem("오후", "저녁 약속", "18:00"),
        ],
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String time, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: time == "오전" ? Colors.orange.shade100 : Colors.green.shade100,
            child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
