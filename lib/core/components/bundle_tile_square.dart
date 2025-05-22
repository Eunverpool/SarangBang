import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/dummy_bundle_model.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({
    super.key,
    required this.data,
    this.onTap,
  });

  final BundleModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: data.isLocked
            ? null // 잠겨있으면 탭 비활성화
            : () {
                Navigator.pushNamed(context, AppRoutes.bundleProduct);
              },
        borderRadius: AppDefaults.borderRadius,
        child: Stack(
          children: [
            Container(
              width: 176,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              decoration: BoxDecoration(
                border: Border.all(width: 0.1, color: AppColors.placeholder),
                borderRadius: AppDefaults.borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
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
                      Text(
                        data.itemNames.join(','),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        data.price != null
                            ? '₩${data.price!.toInt()}'
                            : '가격 미정',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(width: 4),
                      if (data.mainPrice != null)
                        Text(
                          '₩${data.mainPrice!.toInt()}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                        ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (data.isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: const Center(
                    child: Icon(Icons.lock, color: Colors.white, size: 48),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
