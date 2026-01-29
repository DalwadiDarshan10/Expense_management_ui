import 'dart:io';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.userPhone,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 68.w,
              height: 68.w,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? ClipOval(child: _buildAvatarImage())
                    : _buildPlaceholder(),
              ),
            ),
            SizedBox(width: 16.w),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: AppTextStyles.labelLarge.copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    userPhone,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.secondaryText,
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

  Widget _buildAvatarImage() {
    try {
      final file = File(avatarUrl!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: 68.w,
          height: 68.w,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      }
    } catch (e) {
      // If file doesn't exist or error, show placeholder
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Text(
      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
      style: AppTextStyles.titleLarge.copyWith(
        color: AppColors.secondaryText,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
