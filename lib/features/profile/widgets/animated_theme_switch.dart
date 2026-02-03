import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedThemeSwitch extends StatelessWidget {
  const AnimatedThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the ThemeController instance
    final controller = ThemeController.instance;

    return GestureDetector(
      onTap: controller.toggleTheme,
      child: Obx(() {
        final isDarkMode = controller.isDarkMode;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 90,
          height: 45,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isDarkMode ? Colors.black : AppColors.primary,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 400),
            alignment: isDarkMode
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: isDarkMode ? Colors.indigo : Colors.orange,
              ),
            ),
          ),
        );
      }),
    );
  }
}
