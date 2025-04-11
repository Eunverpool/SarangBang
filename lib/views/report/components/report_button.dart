import 'package:flutter/material.dart';

class ReprotButton extends StatelessWidget {
  const ReprotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () {},
          child: const Text('되돌아가기'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('저장하기'),
        ),
      ],
    );
  }
}
