import 'package:barcode_widget/barcode_widget.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/qr/pages/qr_scanner_page.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light grey background
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildTicketCard(),
                    SizedBox(height: 24.h),
                    // herer
                    SizedBox(height: 40.h), // Spacing for bottom tabs
                  ],
                ),
              ),
            ),
            _buildBottomTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.black,
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Share functionality
                },
                child: Icon(
                  Icons.ios_share,
                  color: AppColors.black,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          Text(
            "My QR",
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard() {
    return Stack(
      children: [
        CustomPaint(
          painter: TicketBorderPainter(
            borderColor: AppColors.primary, // Light border
            borderRadius: 20.r,
            cutoutRadius: 15.r,
            yOffsetPercentage: 0.65, // Position of the cutout
          ),
          child: ClipPath(
            clipper: TicketClipper(
              borderRadius: 20.r,
              cutoutRadius: 15.r,
              yOffsetPercentage: 0.65,
            ),
            child: Container(
              width: double.infinity,
              height: 450.h,
              // color: Colors.white,
              child: Column(
                children: [
                  // QR Code Section
                  Expanded(
                    flex: 52,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QrImageView(
                            data: 'https://avipay.com/user/123456',
                            size: 200.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dashed Divider
                  _buildDashedLine(),
                  // Barcode Section
                  Expanded(
                    flex: 28,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h),
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: '2837389129sadh37',
                            drawText: false,
                            color: Colors.black,
                            height: 60.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 20.h),
                          // Download Button
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 24.r,
                            child: AppImageViewer(
                              imagePath: AppImages.downloadIcon,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Overlay border for exact match if needed, but CustomPaint handles it
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: 1,
              color: AppColors.primary, // Dash color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.off(
                () => const QrScannerPage(),
                transition: Transition.fadeIn,
              );
            },
            child: _buildTabItem(
              label: "QR Scan",
              icon: AppImages.scanIcon,
              isActive: false,
            ),
          ),
          SizedBox(width: 60.w),
          _buildTabItem(
            label: "My QR",
            icon: AppImages.myQrcodeIcon,
            isActive: true,
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

class TicketClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutoutRadius;
  final double yOffsetPercentage;

  TicketClipper({
    required this.borderRadius,
    required this.cutoutRadius,
    required this.yOffsetPercentage,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final y = size.height * yOffsetPercentage;

    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, y - cutoutRadius);
    path.arcToPoint(
      Offset(size.width, y + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, y + cutoutRadius);
    path.arcToPoint(
      Offset(0, y - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    return path;
  }

  @override
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Painter for the Ticket Border
class TicketBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double cutoutRadius;
  final double yOffsetPercentage;

  TicketBorderPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.cutoutRadius,
    required this.yOffsetPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors
          .primary // Using Primary Color for border as per design hint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final y = size.height * yOffsetPercentage;

    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, y - cutoutRadius);
    path.arcToPoint(
      Offset(size.width, y + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, y + cutoutRadius);
    path.arcToPoint(
      Offset(0, y - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    canvas.drawPath(path, paint);
  }

  @override
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
