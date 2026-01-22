import 'package:flutter/material.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';

class ActionTile extends StatelessWidget {
  final String title;
  final IconData icon; // Or use SVG path if designs require SVGs
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 26,
          vertical: 12,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: AppColors.surface, // Light background for icon
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          // Assuming H3 or similar exists
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String name;
  final String phone;
  final String? avatarUrl;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.surface,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // In real app, use NetworkImage(avatarUrl) if not null
            ),
          ),
        ),
        title: Text(
          name,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        subtitle: Text(
          phone,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
