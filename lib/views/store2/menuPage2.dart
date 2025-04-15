import 'package:flutter/material.dart';

class menuPage2 extends StatelessWidget {
  const menuPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상점 페이지'),
      ),
      body: const Center(
        child: Text(
          '상점 페이지가 정상적으로 표시됩니다!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
