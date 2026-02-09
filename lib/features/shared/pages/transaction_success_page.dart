import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/core/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

enum TransactionType { topUp, transfer, withdraw }

class TransactionSuccessArgs {
  final TransactionType type;
  final String amount;
  final String? recipientName; // Bank name or Person name
  final String? recipientInfo; // Account number or Phone number

  TransactionSuccessArgs({
    required this.type,
    required this.amount,
    this.recipientName,
    this.recipientInfo,
  });
}

class TransactionSuccessPage extends StatefulWidget {
  const TransactionSuccessPage({super.key});

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments safely
    final TransactionSuccessArgs args = Get.arguments is TransactionSuccessArgs
        ? Get.arguments
        : TransactionSuccessArgs(
            type: TransactionType.topUp,
            amount: "0.00",
            recipientName: "Unknown",
            recipientInfo: "Unknown",
          );

    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? context.theme.scaffoldBackgroundColor
          : AppColors.primary,
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? context.theme.scaffoldBackgroundColor
                      : AppColors.primary,
                ),
                child: const AppImageViewer(
                  imagePath: AppImages.sucessPageBgImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () async {
                  try {
                    await ShareService.captureAndShare(
                      screenshotController: screenshotController,
                    );
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to share receipt: $e",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withValues(alpha: 0.8),
                      colorText: Colors.white,
                    );
                  }
                },
                child: AppImageViewer(imagePath: AppImages.shareIcon),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // The Main Ticket Card
                    CustomPaint(
                      painter: TicketBorderPainter(
                        borderColor: Colors
                            .transparent, // No border visible in image for this card, or maybe white? Using transparent as it looks like just a shape.
                        borderRadius: 20.r,
                        cutoutRadius: 15.r,
                        yOffsetPercentage: 0.55, // Adjusted for visual balance
                      ),
                      child: ClipPath(
                        clipper: TicketClipper(
                          borderRadius: 20.r,
                          cutoutRadius: 15.r,
                          yOffsetPercentage: 0.55,
                        ),
                        child: Container(
                          width: double.infinity,
                          // Height needs to be constrained or calculated.
                          // Using constrained box or fixed height for now to match approx image proportion.
                          height: 480.h,
                          color: context.theme.cardColor,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              // Top Section (Above Cutout)
                              Expanded(
                                flex: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40.h,
                                    ), // Offset for top overlap
                                    Text(
                                      _getTitle(args.type),
                                      style: AppTextStyles.headlineSmall
                                          .copyWith(
                                            color: context
                                                .theme
                                                .textTheme
                                                .headlineSmall
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    SizedBox(height: 14.h),
                                    Text(
                                      _getSubtitle(args.type),
                                      maxLines: 1,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: context
                                            .theme
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 24.h),
                                    Text(
                                      _getAmountLabel(args.type),
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: context
                                            .theme
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "\$ ${args.amount}",
                                      style: AppTextStyles.headlineSmall
                                          .copyWith(
                                            color: context
                                                .theme
                                                .textTheme
                                                .headlineSmall
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Divider Area
                              _buildDashedLine(context),

                              // Bottom Section (Below Cutout)
                              Expanded(
                                flex: 45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Recipient Info Section
                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: context.theme.cardColor,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          AppImageViewer(
                                            imagePath: AppImages.appLogoSquare,

                                            height: 48.h,
                                            width: 48.w,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        args.recipientName ??
                                                            "AVI BANK",
                                                        style: AppTextStyles
                                                            .bodyLarge
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: context
                                                                  .theme
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                            ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        "\$ ${args.amount}", // Showing amount again in the row? Image shows "$ 12,769.00" next to AVI BANK.
                                                        style: AppTextStyles
                                                            .bodyMedium
                                                            .copyWith(
                                                              fontWeight: FontWeight
                                                                  .bold, // Regular weight? Image looks boldish.
                                                              color: context
                                                                  .theme
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  args.recipientInfo ?? "",
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                        color: context
                                                            .theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.color,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        text: "Done",
                                        onPressed: () {
                                          Get.offAllNamed(AppNamed.menuPage);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    // The Overlapping Green Tick
                    Positioned(
                      top: -40.h,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // White border effect
                          Container(
                            height: 70.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color:
                                  context.theme.cardColor, // Matches card color
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Green Icon
                          Container(
                            height: 56.h,
                            width: 56.w,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),

                          // Left Dot
                          Positioned(
                            left: -30.w,
                            top: 50.h,
                            child: _buildDot(
                              size: 22,
                              borderWidth: 4,
                              context: context,
                            ),
                          ),

                          // Right Dot (Medium)
                          Positioned(
                            right: -20.w,
                            top: 32.h,
                            child: _buildDot(
                              size: 18,
                              borderWidth: 4,
                              context: context,
                            ),
                          ),

                          // Right Dot (Small)
                          Positioned(
                            right: -35.w,
                            top: 50.h,
                            child: _buildDot(
                              size: 8,
                              borderWidth: 0,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: 1,
              color: context.theme.dividerColor, // Use theme divider color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot({
    required double size,
    required BuildContext context,
    double borderWidth = 0,
  }) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(color: context.theme.cardColor, width: borderWidth.w)
            : null,
      ),
    );
  }

  String _getTitle(TransactionType type) {
    switch (type) {
      case TransactionType.topUp:
        return "Top Up Success";
      case TransactionType.transfer:
        return "Transfer Success";
      case TransactionType.withdraw:
        return "Withdraw Success";
    }
  }

  String _getSubtitle(TransactionType type) {
    switch (type) {
      case TransactionType.topUp:
        return "Top up has been successfully done";
      case TransactionType.transfer:
        return "Transfer has been successfully done";
      case TransactionType.withdraw:
        return "Top up has been successfully done";
    }
  }

  String _getAmountLabel(TransactionType type) {
    switch (type) {
      case TransactionType.topUp:
        return "Total Top Up";
      case TransactionType.transfer:
        return "Total Transfer";
      case TransactionType.withdraw:
        return "Total Withdraw";
    }
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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
      ..color = borderColor
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
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
