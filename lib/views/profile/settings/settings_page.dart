import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/components/app_back_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/components/app_settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          '설정',
        ),
      ),
      backgroundColor: AppColors.cardColor,
      body: Container(
        margin: const EdgeInsets.all(AppDefaults.padding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          children: [
            AppSettingsListTile(
              label: '알림 설정',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.settingsNotifications),
            ),
            AppSettingsListTile(
              label: '비밀번호 변경',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.changePassword),
            ),
            AppSettingsListTile(
              label: '전화번호 변경',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.changePhoneNumber),
            ),

            // 집주소 변경은 제외
            // AppSettingsListTile(
            //   label: 'Edit Home Address',
            //   trailing: SvgPicture.asset(AppIcons.right),
            //   onTap: () =>
            //       Navigator.pushNamed(context, AppRoutes.deliveryAddress),
            // ),
            AppSettingsListTile(
              label: '종합 보고서 기록 확인',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(
                  context, AppRoutes.deliveryAddress), // 종합보고서 페이지 라우트
            ),
            AppSettingsListTile(
              label: '프로필 설정',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.profileEdit),
            ),
          ],
        ),
      ),
    );
  }
}
