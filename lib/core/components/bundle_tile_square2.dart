import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/dummy_bundle_model.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';
import '../models/dummy_mainbundle_model.dart';

class BundleTileSquare2 extends StatelessWidget {
  const BundleTileSquare2({
    super.key,
    required this.data,
  });

  final MainBundleModel data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, data.route);
        },
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: AppColors.placeholder),
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0), // 원하는 여백 크기 설정 (예: 8.0)
                child: AspectRatio(
                  aspectRatio: 5 / 1,
                  child: NetworkImageWithLoader(
                    data.cover,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  SizedBox(width: 4),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
