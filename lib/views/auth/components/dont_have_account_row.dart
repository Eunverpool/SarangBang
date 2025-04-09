import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class DontHaveAccountRow extends StatelessWidget {
  const DontHaveAccountRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '계정이 없으신가요?',
          style: TextStyle(fontSize: 32),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
          child: const Text(
            '회원가입',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ],
    );
  }
}
