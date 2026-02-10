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
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.voucherTitle, style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.theme.iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: context.theme.cardColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: context.theme.cardColor,
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
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 18.sp,
                        color: context.theme.textTheme.titleMedium?.color,
                      ),
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
              color: context.theme.cardColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.topTrendingDeals,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 18.sp,
                        color: context.theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to View All Page
                        final topTrendingDeals = [
                          {
                            'title': AppStrings.burgerTitle,
                            'description': AppStrings.burgerDesc,
                            'badgeText': AppStrings.freeship,
                            'rating': 4.8,
                          },
                          {
                            'title': AppStrings.sandwichTitle,
                            'description': AppStrings.sandwichDesc,
                            'rating': 4.5,
                          },
                          {
                            'title': AppStrings.pizzaHutTitle,
                            'description': AppStrings.pizzaDesc,
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
                          fontSize: 16.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: context.theme.cardColor,
              height: 170.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  DealCard(
                    title: AppStrings.burgerTitle,
                    description: AppStrings.burgerDesc,
                    badgeText: AppStrings.freeship,
                    rating: 4.8,
                  ),
                  DealCard(
                    title: AppStrings.sandwichTitle,
                    description: AppStrings.sandwichDesc,
                    rating: 4.5,
                  ),
                  DealCard(
                    title: AppStrings.pizzaHutTitle,
                    description: AppStrings.pizzaDesc,
                    rating: 4.9,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Sale Off 50%
            Container(
              color: context.theme.cardColor,
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
                          style: AppTextStyles.titleMedium.copyWith(
                            color: context.theme.textTheme.titleMedium?.color,
                            fontSize: 18.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final saleOffDeals = [
                              {
                                'title': AppStrings.kfcTitle,
                                'description': AppStrings.kfcDesc,
                                'badgeText': AppStrings.halfOffBadge,
                                'rating': 4.7,
                              },
                              {
                                'title': AppStrings.starbucksTitle,
                                'description': AppStrings.coffeeDesc,
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
                              fontSize: 16.sp,
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
                      children: [
                        DealCard(
                          title: AppStrings.kfcTitle,
                          description: AppStrings.kfcDesc,
                          badgeText: AppStrings.halfOffBadge,
                          rating: 4.7,
                        ),
                        DealCard(
                          title: AppStrings.starbucksTitle,
                          description: AppStrings.coffeeDesc,
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
