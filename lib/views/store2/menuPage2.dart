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
        children: [
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
          const SizedBox(height: 20.0), // 캐릭터와 목소리 선택 간의 간격
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDefaults.padding),
              itemCount: Dummy.voices.length,
              itemBuilder: (context, index) {
                return VoiceTile(
                  title: Dummy.voices[index],
                  onTap: () {
                    // 목소리 선택 시 기능 추가 가능
                    print('${Dummy.voices[index]} 선택됨');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
