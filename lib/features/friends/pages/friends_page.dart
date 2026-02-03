import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Friends',
          style: AppTextStyles.titleLarge.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          Obx(
            () => controller.isDeleteMode.value
                ? IconButton(
                    onPressed: () => controller.toggleDeleteMode(),
                    icon: Icon(
                      Icons.check,
                      color: Theme.of(context).iconTheme.color,
                      size: 24.r,
                    ),
                  )
                : IconButton(
                    onPressed: () => controller.toggleDeleteMode(),
                    icon: AppImageViewer(
                      height: 24.r,
                      width: 24.r,
                      imagePath: AppImages.deleteIcon,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            // Add New Friend Button
            GestureDetector(
              onTap: () {
                Get.toNamed(AppNamed.addNewFriend);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Add New Friend',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // Friends List
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Obx(() {
                final grouped = controller.groupedFriends;
                final sortedKeys = grouped.keys.toList()..sort();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, sectionIndex) {
                    final letter = sortedKeys[sectionIndex];
                    final friends = grouped[letter]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        // Section Header
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 24.w,
                            top: 16.h,
                            bottom: 8.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    controller.toggleGroupSelection(letter),
                                child: Container(
                                  width: 32.r,
                                  height: 32.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    letter,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (sectionIndex == 0)
                                GestureDetector(
                                  onTap: () {
                                    controller.toggleGroupSelection(letter);
                                  },
                                  child: Text(
                                    'Choose',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Friends in this section
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friends.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                            indent: 60.w,
                          ),
                          itemBuilder: (context, index) {
                            final friend = friends[index];
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 16.w,
                              ),
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    // Only show checkbox in delete mode
                                    if (controller.isDeleteMode.value) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: GestureDetector(
                                          onTap: () => controller
                                              .toggleSelection(friend),
                                          child: Container(
                                            width: 20.r,
                                            height: 20.r,
                                            decoration: BoxDecoration(
                                              color: friend.isSelected.value
                                                  ? AppColors.primary
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                              border: Border.all(
                                                color: friend.isSelected.value
                                                    ? AppColors.primary
                                                    : Theme.of(
                                                            context,
                                                          ).iconTheme.color ??
                                                          AppColors
                                                              .secondaryText,
                                              ),
                                            ),
                                            child: friend.isSelected.value
                                                ? Icon(
                                                    Icons.check,
                                                    size: 14.r,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),

                                  // Custom Avatar as per user request
                                  Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            friend.name.isNotEmpty
                                                ? friend.name[0].toUpperCase()
                                                : '?',
                                            style: AppTextStyles.titleMedium
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                friend.name,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                friend.phone,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
