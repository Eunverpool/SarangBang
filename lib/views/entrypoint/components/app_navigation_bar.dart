import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'bottom_app_bar_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: AppDefaults.margin,
      color: AppColors.scaffoldBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ← 삭제해도 됨
        children: [
          Expanded(
            child: BottomAppBarItem(
              name: '집',
              iconLocation: const Icon(Icons.home, size: 25),
              isActive: currentIndex == 0,
              onTap: () => onNavTap(0),
            ),
          ),
          Expanded(
            child: BottomAppBarItem(
              name: '일지',
              iconLocation: const Icon(Icons.calendar_month, size: 25),
              isActive: currentIndex == 1,
              onTap: () => onNavTap(1),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppDefaults.padding * 1.5),
            child: SizedBox(width: AppDefaults.margin),
          ),
          Expanded(
            child: BottomAppBarItem(
              name: '상점',
              iconLocation: const Icon(Icons.shopping_cart, size: 25),
              isActive: currentIndex == 3,
              onTap: () => onNavTap(3),
            ),
          ),
          Expanded(
            child: BottomAppBarItem(
              name: '내 정보',
              iconLocation: const Icon(Icons.account_circle, size: 25),
              isActive: currentIndex == 4,
              onTap: () => onNavTap(4),
            ),
          ),
        ],
      ),
    );
  }
}
