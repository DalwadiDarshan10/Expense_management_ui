import 'package:camera/camera.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controllers/face_id_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceIdPage extends StatelessWidget {
  const FaceIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaceIdController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () {
            Get.delete<FaceIdController>();
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          AppStrings.faceIdTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              AppStrings.faceRecognition,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.faceRecognitionMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: 40.h),
            // Scanner Area with Live Camera
            Expanded(
              child: Center(
                child: Container(
                  width: 280.w,
                  height: 400.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Camera Preview
                      Obx(() {
                        if (controller.hasPermission.value) {
                          if (controller.isCameraInitialized.value &&
                              controller.cameraController != null) {
                            return AspectRatio(
                              aspectRatio: controller
                                  .cameraController!
                                  .value
                                  .aspectRatio,
                              child: CameraPreview(
                                controller.cameraController!,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                Text(AppStrings.cameraPermission),
                                TextButton(
                                  onPressed: () => openAppSettings(),
                                  child: Text(AppStrings.openSettings),
                                ),
                              ],
                            ),
                          );
                        }
                      }),

                      // Corner brackets overlay
                      Positioned(
                        top: 20.h,
                        left: 20.w,
                        child: const _CornerBracket(isTop: true, isLeft: true),
                      ),
                      Positioned(
                        top: 20.h,
                        right: 20.w,
                        child: const _CornerBracket(isTop: true, isLeft: false),
                      ),
                      Positioned(
                        bottom: 60.h,
                        left: 20.w,
                        child: const _CornerBracket(isTop: false, isLeft: true),
                      ),
                      Positioned(
                        bottom: 60.h,
                        right: 20.w,
                        child: const _CornerBracket(
                          isTop: false,
                          isLeft: false,
                        ),
                      ),

                      // Gradient overlay for better UI integration
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                                stops: const [0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom controls inside the card
                      Positioned(
                        bottom: 16.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(
                              () => _IconLabelButton(
                                icon: controller.isFlashOn.value
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                label: AppStrings.flashlight,
                                context: context,
                                color: controller.isFlashOn.value
                                    ? AppColors.primary
                                    : null,
                                onTap: controller.toggleFlash,
                              ),
                            ),
                            _IconLabelButton(
                              icon: Icons.image,
                              label: AppStrings.images,
                              context: context,
                              onTap: controller.pickImageFromGallery,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            AppButton(
              text: AppStrings.scanMyFace,
              onPressed: () {
                Get.snackbar(AppStrings.faceIdTitle, "Scanning face... (Mock)");
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                Get.delete<FaceIdController>();
                Get.back();
              },
              child: Text(
                AppStrings.skip,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: AppColors.primary, width: 3.w)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: AppColors.primary, width: 3.w)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: AppColors.primary, width: 3.w)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: AppColors.primary, width: 3.w)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final BuildContext context;
  final VoidCallback onTap;
  final Color? color;

  const _IconLabelButton({
    required this.icon,
    required this.label,
    required this.context,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: color ?? AppColors.white.withOpacity(0.9),
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
