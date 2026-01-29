import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/voucher/widgets/banner_carousel.dart';
import 'package:expense/features/voucher/widgets/category_item.dart';
import 'package:expense/features/voucher/widgets/deal_card.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.voucherTitle, style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const BannerCarousel(),
                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      AppStrings.categories,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: 100.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryItem(
                            title: AppStrings.categoryAll,
                            icon: Icons.grid_view_rounded,
                            color: AppColors
                                .primary, // Using primary for "All" based on design (blueish)
                            onTap: () {},
                            isSelected: false,
                          ),
                          SizedBox(width: 20.w),
                          CategoryItem(
                            title: AppStrings.categoryInternet,
                            icon: Icons.wifi,
                            color: AppColors.interactive, // Blue
                            onTap: () {},
                          ),
                          SizedBox(width: 20.w),
                          CategoryItem(
                            title: AppStrings.categoryElectricity,
                            icon: Icons.electric_bolt,
                            color: AppColors.primarySup, // Yellow/Amber
                            onTap: () {},
                          ),
                          SizedBox(width: 20.w),
                          CategoryItem(
                            title: AppStrings.categoryMarket,
                            icon: Icons.shopping_cart,
                            color: AppColors.success, // Green
                            onTap: () {},
                          ),
                          SizedBox(width: 20.w),
                          CategoryItem(
                            title: AppStrings.categoryMedical,
                            icon: Icons.medical_services,
                            color: AppColors.critical, // Red
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // Top Trending Deals
            Container(
              padding: EdgeInsets.only(bottom: 16.h, top: 12.h),
              color: AppColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.topTrendingDeals,
                      style: AppTextStyles.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to View All Page
                        final topTrendingDeals = [
                          {
                            'title': 'Chillox Burger',
                            'description': 'Burgers • Fastfood',
                            'badgeText': 'Freeship',
                            'rating': 4.8,
                          },
                          {
                            'title': 'Sandwich',
                            'description': 'Sandwich • Fastfood',
                            'rating': 4.5,
                          },
                          {
                            'title': 'Pizza Hut',
                            'description': 'Pizza',
                            'rating': 4.9,
                          },
                        ];
                        Get.toNamed(
                          AppNamed.voucherDeals,
                          arguments: {
                            'title': AppStrings.topTrendingDeals,
                            'deals': topTrendingDeals,
                          },
                        );
                      },
                      child: Text(
                        AppStrings.viewAll,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors.white,
              height: 170.h,
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
            SizedBox(height: 8.h),
            // Sale Off 50%
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.saleOff50,
                          style: AppTextStyles.titleMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            final saleOffDeals = [
                              {
                                'title': 'KFC Chicken',
                                'description': 'Fried Chicken',
                                'badgeText': '50% OFF',
                                'rating': 4.7,
                              },
                              {
                                'title': 'Starbucks',
                                'description': 'Coffee',
                                'rating': 4.6,
                              },
                            ];
                            Get.toNamed(
                              AppNamed.voucherDeals,
                              arguments: {
                                'title': AppStrings.saleOff50,
                                'deals': saleOffDeals,
                              },
                            );
                          },
                          child: Text(
                            AppStrings.viewAll,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 170.h,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
