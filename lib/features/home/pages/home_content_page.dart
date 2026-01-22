import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        // Blue curved background using SVG image
        SizedBox(
          height: 230.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.r),
              bottomRight: Radius.circular(32.r),
            ),
            child: AppImageViewer(
              imagePath: AppImages.menuPageBackground,
              fit: BoxFit.fill,
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
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppNamed.notificationPage);
                      },
                      child: Container(
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
                                  color: AppColors.primarySup,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Balance Section
                Text(
                  'Balance',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$12,769.00',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.primarySup,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18.h),
                // Action Buttons Row
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.backLanding,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppNamed.topUpPage);
                          },
                          child: _buildActionButton(
                            icon: AppImages.topupIcon,
                            label: 'Top up',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppNamed.walletsDashboard);
                          },
                          child: _buildActionButton(
                            icon: AppImages.walletIcon,
                            label: 'Wallet',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppNamed.scannerPage);
                          },
                          child: _buildActionButton(
                            icon: AppImages.scanIcon,
                            label: 'QR Scan',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppNamed.myQrPage);
                          },
                          child: _buildActionButton(
                            icon: AppImages.myQrcodeIcon,
                            label: 'My QR',
                          ),
                        ),
                      ],
                    ),
                  ),
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
        AppImageViewer(imagePath: icon, height: 24.h, width: 24.w),
        SizedBox(height: 5.h),
        Text(label),
      ],
    );
  }

  Widget _buildSendAgainSection() {
    final contacts = [
      {'name': 'John', 'color': const Color(0xFFFFB74D)},
      {'name': 'Lovi ', 'color': const Color(0xFF4FC3F7)},
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
            height: 90.h,
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
      mainAxisSize: MainAxisSize.min, // ✅ FIX
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Center(
            child: Container(
              width: 48.w,
              height: 48.w,
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
          ),
        ),
        SizedBox(height: 6.h), // slightly reduced
        SizedBox(
          width: 64.w,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.secondaryText,
              height: 1.2, // ✅ tighter line height
            ),
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
        // 'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.internetBadge,
        'label': 'Internet',
        // 'color': const Color(0xFF9C27B0),
      },
      {
        'icon': AppImages.insuranceBadge,
        'label': 'Insurance',
        // 'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.medicalBadge,
        'label': 'Medical',
        // 'color': const Color(0xFFF44336),
      },
      {
        'icon': AppImages.marketBadge,
        'label': 'Market',
        // 'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.electricBillBadge,
        'label': 'Electric bill',
        // 'color': const Color(0xFFFF9800),
      },
      {
        'icon': AppImages.televisionBadge,
        'label': 'Television',
        // 'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.waterbillBadge,
        'label': 'Waterbill',
        // 'color': const Color(0xFF03A9F4),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 11.h,
              // crossAxisSpacing: 1.w,
              childAspectRatio: 0.85,
            ),
            itemCount: paymentItems.length,
            itemBuilder: (context, index) {
              final item = paymentItems[index];
              return _buildPaymentItem(
                icon: item['icon'] as String,
                label: item['label'] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({required String icon, required String label}) {
    return Column(
      children: [
        AppImageViewer(imagePath: icon, height: 56.h, width: 56.w),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
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
            title: 'Electric Bill',
            subtitle: 'Sent',
            amount: '-\$420',
            isNegative: true,
            date: "Today - 3.14",
          ),
          SizedBox(height: 20.h),
          _buildTransactionItem(
            icon: AppImages.televisionBadge,
            title: 'Television Bill',
            subtitle: 'Sent',
            amount: '\$420',
            isNegative: true,
            date: "22 jan- 3.14",
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
    required String date,
  }) {
    return Row(
      children: [
        AppImageViewer(imagePath: icon, height: 56.h, width: 56.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    amount,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isNegative
                          ? AppColors.success
                          : AppColors.primaryText,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    date,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
