import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuPagee extends StatelessWidget {
  const MenuPagee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Blue Header Section with Background Image
            _buildHeaderSection(context),
            SizedBox(height: 24.h),
            // Send Again Section
            _buildSendAgainSection(),
            SizedBox(height: 24.h),
            // Payment List Section
            _buildPaymentListSection(),
            SizedBox(height: 24.h),
            // Trading History Section
            _buildTradingHistorySection(),
            SizedBox(height: 100.h), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        // Blue curved background using SVG image
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.r),
              bottomRight: Radius.circular(32.r),
            ),
            child: AppImageViewer(
              imagePath: AppImages.menuPageBackground,
              height: 280.h,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content on top of the background
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                // Notification row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      child: Stack(
                        children: [
                          AppImageViewer(
                            imagePath: AppImages.notificationIcon,
                            height: 24.h,
                            width: 24.w,
                            color: Colors.white,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Balance Section
                Text(
                  'Balance',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$12,769.00',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: AppImages.topupIcon,
                      label: 'Top up',
                    ),
                    _buildActionButton(
                      icon: AppImages.walletIcon,
                      label: 'Wallet',
                    ),
                    _buildActionButton(
                      icon: AppImages.scanIcon,
                      label: 'QR Scan',
                    ),
                    _buildActionButton(
                      icon: AppImages.myQrcodeIcon,
                      label: 'My QR',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: AppImageViewer(
            imagePath: icon,
            height: 24.h,
            width: 24.w,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSendAgainSection() {
    final contacts = [
      {'name': 'John', 'color': const Color(0xFFFFB74D)},
      {'name': 'Lovi William', 'color': const Color(0xFF4FC3F7)},
      {'name': 'Hametrius', 'color': const Color(0xFFE57373)},
      {'name': 'Leshaad', 'color': const Color(0xFF81C784)},
      {'name': 'Lane R.', 'color': const Color(0xFFBA68C8)},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Again',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: contacts.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _buildContactAvatar(
                  name: contact['name'] as String,
                  color: contact['color'] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAvatar({required String name, required Color color}) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 60.w,
          child: Text(
            name,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentListSection() {
    final paymentItems = [
      {
        'icon': AppImages.electricityBadge,
        'label': 'Electricity',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.internetBadge,
        'label': 'Internet',
        'color': const Color(0xFF9C27B0),
      },
      {
        'icon': AppImages.insuranceBadge,
        'label': 'Insurance',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.medicalBadge,
        'label': 'Medical',
        'color': const Color(0xFFF44336),
      },
      {
        'icon': AppImages.marketBadge,
        'label': 'Market',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.electricBillBadge,
        'label': 'Electric bill',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': AppImages.televisionBadge,
        'label': 'Television',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.waterbillBadge,
        'label': 'Waterbill',
        'color': const Color(0xFF03A9F4),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment List',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.85,
            ),
            itemCount: paymentItems.length,
            itemBuilder: (context, index) {
              final item = paymentItems[index];
              return _buildPaymentItem(
                icon: item['icon'] as String,
                label: item['label'] as String,
                backgroundColor: item['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String icon,
    required String label,
    required Color backgroundColor,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: AppImageViewer(imagePath: icon, height: 28.h, width: 28.w),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTradingHistorySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading History',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTransactionItem(
            icon: AppImages.electricBillBadge,
            title: 'Electric bill',
            subtitle: 'Sent',
            amount: '-\$420',
            isNegative: true,
            backgroundColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isNegative,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: AppImageViewer(imagePath: icon, height: 24.h, width: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isNegative ? AppColors.primaryText : AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home_filled, isSelected: true),
            _buildNavItem(icon: Icons.bar_chart_rounded, isSelected: false),
            _buildNavItem(icon: Icons.settings, isSelected: false),
            _buildNavItem(icon: Icons.person_outline, isSelected: false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required bool isSelected}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.secondaryText,
        size: 24.sp,
      ),
    );
  }
}
