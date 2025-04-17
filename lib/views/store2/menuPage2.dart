import 'package:flutter/material.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';

class menuPage2 extends StatelessWidget {
  const menuPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0), // 좌우 패딩 추가
          child: TitleAndActionButton(
            title: '상점 페이지',
            onTap: () => Navigator.pushNamed(context, AppRoutes.popularItems),
          ),
        ),
        const SizedBox(height: 100.0), // 제목과 스크롤 뷰 사이의 간격
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: AppDefaults.padding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              Dummy.bundles.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: AppDefaults.padding),
                child: BundleTileSquare(data: Dummy.bundles[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
