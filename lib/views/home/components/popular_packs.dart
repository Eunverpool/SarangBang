import 'package:flutter/material.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/constants/constants.dart';

class PopularPacks extends StatelessWidget {
  const PopularPacks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽 (0번째, 정상)
          BundleTileSquare(data: Dummy.mainbundles[0]),

          // 가운데 (1번째, 약간 위로)
          BundleTileSquare(data: Dummy.mainbundles[1]),

          // 오른쪽 (2번째, 정상)
          BundleTileSquare(data: Dummy.mainbundles[2]),
        ],
      ),
    );
  }
}
