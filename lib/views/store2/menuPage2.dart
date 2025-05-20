import 'package:flutter/material.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/dummy_data.dart';
import 'voice_title.dart';

class menuPage2 extends StatelessWidget {
  const menuPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상점 페이지'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Text(
              '구매하고 싶은 캐릭터를 선택하세요',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: AppDefaults.padding),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                Dummy.bundles.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: AppDefaults.padding),
                  child: BundleTileSquare(
                    data: Dummy.bundles[index],
                    onTap: () {
                      // 원하는 동작을 여기에 작성하세요. 예시: 다이얼로그 표시
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('${Dummy.bundles[index].name} 선택'),
                          content: const Text('캐릭터를 선택하셨습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Text(
              '원하는 캐릭터를 선택해 다양한 목소리와 함께 대화를 시작해보세요!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
