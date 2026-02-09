import 'package:expense/core/constants/app_strings.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense/features/qr/controller/my_qr_controller.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyQrController());

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Light grey background
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: EdgeInsets.all(16.h.w),
                        child: _buildTicketCard(context, controller),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildCouponSection(context, controller),
                    SizedBox(height: 8.h),
                    _buildPointsSection(context), // Spacing for bottom tabs
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
                  color: Theme.of(context).iconTheme.color,
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppNamed.shareQr);
                },
                child: AppImageViewer(
                  imagePath: AppImages.shareIcon,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Text(
            AppStrings.myQr,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, MyQrController controller) {
    return RepaintBoundary(
      key: controller.ticketKey,
      child: Stack(
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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    // QR Code Section
                    Expanded(
                      flex: 52,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: QrImageView(
                                  data: controller.currentUserUid,
                                  size: 180.w,
                                ),
                              ),
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
                            Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Container(
                                color: Colors.white,
                                child: BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  data: controller.currentUserUid,
                                  drawText: false,
                                  color: Colors.black,
                                  height: 50.h,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // Download Button
                            GestureDetector(
                              onTap: controller.downloadQrAndBarcode,
                              child: Obx(
                                () => CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 24.r,
                                  child: controller.isDownloading
                                      ? SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : AppImageViewer(
                                          imagePath: AppImages.downloadIcon,
                                          height: 20.h,
                                          width: 20.w,
                                          color: Colors.white,
                                        ),
                                ),
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
      ),
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

  Widget _buildCouponSection(BuildContext context, MyQrController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          AppImageViewer(
            imagePath: AppImages.couponIcon,
            height: 24.h,
            width: 24.w,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(width: 12.w),
          Text(
            AppStrings.couponLabel,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: controller.couponController,
                decoration: InputDecoration(
                  hintText: AppStrings.couponHint,
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.hintText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.h),
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: controller.applyCoupon,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          AppImageViewer(
            imagePath: AppImages.starIcon,
            height: 24.h,
            width: 24.w,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.usePointsLabel,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(
            '4000',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppColors.secondaryText,
          ),
        ],
      ),
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
