import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ReprotButton extends StatelessWidget {
  const ReprotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            side: BorderSide(color: AppColors.primary),
            textStyle: TextStyle(fontSize: 21), // 글씨 크기 증가
            minimumSize: Size(150, 60), // 버튼 최소 크기 설정
          ),
          child: const Text('공유하기'),
        ),
        // SizedBox(width: 8), // 버튼 사이 간격 조절
        // OutlinedButton(
        //   onPressed: () {},
        //   style: OutlinedButton.styleFrom(
        //     backgroundColor: Colors.white,
        //     foregroundColor: Colors.black,
        //     side: BorderSide(color: Colors.black),
        //   ),
        //   child: const Text('공유하기'),
        //),
      ],
    );
  }
}
