import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/voucher/widgets/deal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoucherDealsPage extends StatelessWidget {
  const VoucherDealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String title = args['title'] ?? 'Deals';
    final List<Map<String, dynamic>> deals = List<Map<String, dynamic>>.from(
      args['deals'] ?? [],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: deals.isEmpty
          ? Center(
              child: Text(
                'No deals available',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.8, // Adjust ratio as needed for DealCard
              ),
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return DealCard(
                  title: deal['title'] ?? '',
                  description: deal['description'] ?? '',
                  badgeText: deal['badgeText'],
                  rating: (deal['rating'] as num?)?.toDouble() ?? 0.0,
                );
              },
            ),
    );
  }
}
