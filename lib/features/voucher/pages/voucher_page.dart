import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/voucher/widgets/banner_carousel.dart';
import 'package:expense/features/voucher/widgets/category_item.dart';
import 'package:expense/features/voucher/widgets/deal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Voucher', style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Add extra padding or icon if needed to balance
          SizedBox(width: 40.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BannerCarousel(),

            SizedBox(height: 20.h),

            // Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text('Categories', style: AppTextStyles.titleMedium),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 100.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  CategoryItem(
                    title: 'All',
                    icon: Icons.grid_view_rounded,
                    color: AppColors
                        .primary, // Using primary for "All" based on design (blueish)
                    onTap: () {},
                    isSelected: false,
                  ),
                  SizedBox(width: 20.w),
                  CategoryItem(
                    title: 'Internet',
                    icon: Icons.wifi,
                    color: AppColors.interactive, // Blue
                    onTap: () {},
                  ),
                  SizedBox(width: 20.w),
                  CategoryItem(
                    title: 'Electricity',
                    icon: Icons.electric_bolt,
                    color: AppColors.primarySup, // Yellow/Amber
                    onTap: () {},
                  ),
                  SizedBox(width: 20.w),
                  CategoryItem(
                    title: 'Market',
                    icon: Icons.shopping_cart,
                    color: AppColors.success, // Green
                    onTap: () {},
                  ),
                  SizedBox(width: 20.w),
                  CategoryItem(
                    title: 'Medical',
                    icon: Icons.medical_services,
                    color: AppColors.critical, // Red
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Top Trending Deals
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top Trending Deals', style: AppTextStyles.titleMedium),
                  Text(
                    'View all',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h, // Adjusted height for deal cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: const [
                  DealCard(
                    title: 'Chillox Burger',
                    description: 'Burgers • Fastfood',
                    badgeText: 'Freeship',
                    rating: 4.8,
                  ),
                  DealCard(
                    title: 'Sandwich',
                    description: 'Sandwich • Fastfood',
                    rating: 4.5,
                  ),
                  DealCard(
                    title: 'Pizza Hut',
                    description: 'Pizza',
                    rating: 4.9,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Sale Off 50%
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sale Off 50%', style: AppTextStyles.titleMedium),
                  Text(
                    'View all',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Just replicating the deals for the "Sale Off" section as placeholder for now,
            // or I can put a different placeholder.
            // The design shows similar cards.
            SizedBox(
              height: 200.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: const [
                  DealCard(
                    title: 'KFC Chicken',
                    description: 'Fried Chicken',
                    badgeText: '50% OFF',
                    rating: 4.7,
                  ),
                  DealCard(
                    title: 'Starbucks',
                    description: 'Coffee',
                    rating: 4.6,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
