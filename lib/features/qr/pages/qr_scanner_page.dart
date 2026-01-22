import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/qr/controller/qr_scanner_controller.dart';
import 'package:expense/features/qr/pages/my_qr_page.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends GetView<QrScannerController> {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.cover,
            controller: controller.scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                // Handle success (e.g., show result)
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),
          _buildOverlay(),
          _buildTopBar(),
          _buildControls(),
          _buildBottomTabs(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Obx(() {
      final isQr = controller.isQrMode.value;
      return Container(
        decoration: ShapeDecoration(
          shape: QrScannerOverlayShape(
            borderColor: AppColors.white,
            borderRadius: 16,
            borderLength: 30,
            borderWidth: 10,
            cutoutWidth: isQr ? 300.w : 300.w,
            cutoutHeight: isQr ? 300.w : 150.h, // Adjusted for Barcode shape
          ),
        ),
      );
    });
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
          // Gallery Icon
          GestureDetector(
            onTap: controller.pickImageFromGallery,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.image, color: AppColors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 180.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Flashlight
          Obx(
            () => GestureDetector(
              onTap: controller.toggleTorch,
              child: Column(
                children: [
                  Icon(
                    controller.isTorchOn.value
                        ? Icons.flashlight_on
                        : Icons.flashlight_off,
                    color: AppColors.white,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Flashlight",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Switch Mode Button
          Obx(() {
            final isQr = controller.isQrMode.value;
            return GestureDetector(
              onTap: controller.switchMode,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isQr ? Icons.document_scanner : Icons.qr_code,
                      color: AppColors.black,
                    ), // Dynamic icon
                    SizedBox(width: 8.w),
                    Text(
                      isQr ? "Switch to barcode" : "Switch to QR Code",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Positioned(
      bottom: 40.h,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabItem(
            label: "QR Scan",
            icon: AppImages.scanIcon,
            isActive: true, // Always active on this page
          ),
          SizedBox(width: 60.w),
          GestureDetector(
            onTap: () {
              // Replace current route with MyQR Page without animation
              // Or navigate to MyQR page
              Get.off(() => const MyQrPage(), transition: Transition.fadeIn);
            },
            child: _buildTabItem(
              // Should be inactive look but navigable
              label: "My QR",
              icon: AppImages.myQrcodeIcon,
              isActive: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required String icon,
    required bool isActive,
  }) {
    return Column(
      children: [
        AppImageViewer(
          imagePath: icon,
          height: 24.h,
          width: 24.w,
          color: isActive ? AppColors.primarySup : AppColors.secondaryText,
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? AppColors.primarySup : AppColors.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Custom Overlay Shape mostly used for QR scanners (found in previous implementations or available online)
// MobileScanner has a built-in overlay but customization is limited.
// Using a Container with ShapeDecoration and a custom QrScannerOverlayShape class is common.
// I'll assume standard Flutter ShapeBorder implementation.

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutoutWidth;
  final double cutoutHeight;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutoutWidth = 250,
    this.cutoutHeight = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);

    Rect cutoutRect = Rect.fromCenter(
      center: rect.center,
      width: cutoutWidth,
      height: cutoutHeight,
    );

    path.addRRect(
      RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius)),
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // final width = rect.width; // Unused
    // final borderWidthSize = width / 2; // Unused
    // final height = rect.height; // Unused
    // final borderOffset = borderWidth / 2; // Unused
    final iconHeight = cutoutHeight;
    final iconWidth = cutoutWidth;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutoutRect = Rect.fromCenter(
      center: rect.center,
      width: iconWidth,
      height: iconHeight,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(
          RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius)),
        ),
      ),
      backgroundPaint,
    );

    // Draw corners
    // Top left
    final path = Path();
    path.moveTo(cutoutRect.left, cutoutRect.top + borderLength);
    path.lineTo(cutoutRect.left, cutoutRect.top + borderRadius);
    path.quadraticBezierTo(
      cutoutRect.left,
      cutoutRect.top,
      cutoutRect.left + borderRadius,
      cutoutRect.top,
    );
    path.lineTo(cutoutRect.left + borderLength, cutoutRect.top);

    // Top right
    path.moveTo(cutoutRect.right - borderLength, cutoutRect.top);
    path.lineTo(cutoutRect.right - borderRadius, cutoutRect.top);
    path.quadraticBezierTo(
      cutoutRect.right,
      cutoutRect.top,
      cutoutRect.right,
      cutoutRect.top + borderRadius,
    );
    path.lineTo(cutoutRect.right, cutoutRect.top + borderLength);

    // Bottom right
    path.moveTo(cutoutRect.right, cutoutRect.bottom - borderLength);
    path.lineTo(cutoutRect.right, cutoutRect.bottom - borderRadius);
    path.quadraticBezierTo(
      cutoutRect.right,
      cutoutRect.bottom,
      cutoutRect.right - borderRadius,
      cutoutRect.bottom,
    );
    path.lineTo(cutoutRect.right - borderLength, cutoutRect.bottom);

    // Bottom left
    path.moveTo(cutoutRect.left + borderLength, cutoutRect.bottom);
    path.lineTo(cutoutRect.left + borderRadius, cutoutRect.bottom);
    path.quadraticBezierTo(
      cutoutRect.left,
      cutoutRect.bottom,
      cutoutRect.left,
      cutoutRect.bottom - borderRadius,
    );
    path.lineTo(cutoutRect.left, cutoutRect.bottom - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      overlayColor: overlayColor,
      borderRadius: borderRadius * t,
      borderLength: borderLength * t,
      cutoutWidth: cutoutWidth * t,
      cutoutHeight: cutoutHeight * t,
    );
  }
}
