import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:expense/features/analytics/pages/analytics_page.dart';
import 'package:expense/features/home/pages/home_content_page.dart';
import 'package:expense/features/home/widgets/bottom_nav_bar_widget.dart';
import 'package:expense/features/profile/controller/profile_controller.dart';
import 'package:expense/features/profile/pages/profile_page.dart';
import 'package:expense/features/voucher/pages/voucher_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ================= CONTROLLER =================
class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

/// ================= PAGE =================
class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  final MainNavigationController controller = Get.put(
    MainNavigationController(),
  );
  final AnalyticsController analyticsController = Get.put(
    AnalyticsController(),
  );
  final ProfileController profileController = Get.put(ProfileController());
  final WalletController walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomePage(),
            AnalyticsPage(),
            VoucherPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
