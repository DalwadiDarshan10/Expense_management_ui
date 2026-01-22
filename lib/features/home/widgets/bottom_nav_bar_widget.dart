import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/features/home/pages/main_navigation_page.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Navigation item configuration
class NavItem {
  final String activeIcon;
  final String inactiveIcon;

  const NavItem({required this.activeIcon, required this.inactiveIcon});
}

/// Bottom Navigation Bar Widget
class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  /// List of navigation items - easy to add/remove/reorder
  static const List<NavItem> _navItems = [
    NavItem(
      activeIcon: AppImages.homeActive,
      inactiveIcon: AppImages.homeInactive,
    ),
    NavItem(
      activeIcon: AppImages.chartActive,
      inactiveIcon: AppImages.chartInactive,
    ),
    NavItem(
      activeIcon: AppImages.discountActive,
      inactiveIcon: AppImages.discountInactive,
    ),
    NavItem(
      activeIcon: AppImages.profileActive,
      inactiveIcon: AppImages.profileInactive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainNavigationController>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(
                item: _navItems[index],
                isSelected: controller.currentIndex.value == index,
                onTap: () => controller.changePage(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AppImageViewer(
          imagePath: isSelected ? item.activeIcon : item.inactiveIcon,
          height: 24.h,
          width: 24.w,
        ),
      ),
    );
  }
}
