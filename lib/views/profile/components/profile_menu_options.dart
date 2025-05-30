import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import 'profile_list_tile.dart';

class ProfileMenuOptions extends StatelessWidget {
  const ProfileMenuOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        children: [
          ProfileListTile(
            title: '보호자 등록',
            icon: AppIcons.profilePerson,
            onTap: () => Navigator.pushNamed(context, AppRoutes.profileEdit),
          ),
          // const Divider(thickness: 0.1),
          // ProfileListTile(
          //   title: '알림',
          //   icon: AppIcons.profileNotification,
          //   onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          // ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: '설정',
            icon: AppIcons.profileSetting,
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: '결제수단',
            icon: AppIcons.profilePayment,
            onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethod),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: '로그인하기',
            icon: AppIcons.profileLogout,
            onTap: () => Navigator.pushNamed(context, AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
