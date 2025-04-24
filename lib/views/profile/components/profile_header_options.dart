import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import 'profile_squre_tile.dart';

class ProfileHeaderOptions extends StatelessWidget {
  const ProfileHeaderOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        boxShadow: AppDefaults.boxShadow,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ProfileSqureTile(
              label: '종합보고서',
              icon: AppIcons.truckIcon,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.myOrder);
              },
            ),
          ),
          Expanded(
            child: ProfileSqureTile(
              label: '쿠폰',
              icon: AppIcons.voucher,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.coupon);
              },
            ),
          ),
          Expanded(
            child: ProfileSqureTile(
              label: '공지사항',
              icon: AppIcons.homeProfile,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.deliveryAddress);
              },
            ),
          )
        ],
      ),
    );
  }
}
