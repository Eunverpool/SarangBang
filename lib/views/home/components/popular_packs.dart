import 'package:flutter/material.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/components/bundle_tile_square2.dart';
import '../../../core/constants/constants.dart';

class PopularPacks extends StatelessWidget {
  const PopularPacks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Column(
        // Row 대신 Column 사용
        crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 가로로 최대한 늘림
        children: [
          // 1번째 아이템
          Padding(
            padding:
                const EdgeInsets.only(bottom: AppDefaults.padding), // 아래쪽 간격 추가
            child: BundleTileSquare2(
              data: Dummy.mainbundles[0],
            ),
          ),

          // 2번째 아이템
          Padding(
            padding:
                const EdgeInsets.only(bottom: AppDefaults.padding), // 아래쪽 간격 추가
            child: BundleTileSquare2(data: Dummy.mainbundles[1]),
          ),

          // 3번째 아이템
          BundleTileSquare2(data: Dummy.mainbundles[2]),
        ],
      ),
    );
  }
}
