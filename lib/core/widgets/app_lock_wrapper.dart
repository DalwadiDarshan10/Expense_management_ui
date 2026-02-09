import 'package:expense/features/profile/controller/security_controller.dart';
import 'package:expense/features/profile/pages/pin_lock_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLockWrapper extends StatelessWidget {
  final Widget child;

  const AppLockWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final securityController = Get.find<SecurityController>();

    return Obx(
      () => Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => securityController.resetInactivityTimer(),
            onPointerUp: (_) => securityController.resetInactivityTimer(),
            onPointerMove: (_) => securityController.resetInactivityTimer(),
            child: child,
          ),
          if (securityController.isLocked.value) const PinLockPage(),
        ],
      ),
    );
  }
}
