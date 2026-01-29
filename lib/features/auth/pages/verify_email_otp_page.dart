import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/auth/controller/forgot_password_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyEmailOtpPage extends StatelessWidget {
  const VerifyEmailOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.verificationTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                24.verticalSpace,
                _buildIllustration(),
                32.verticalSpace,
                _buildTitle(),
                12.verticalSpace,
                _buildSubtitle(controller),
                40.verticalSpace,
                _buildOtpInputs(controller),
                _buildOtpError(controller),
                40.verticalSpace,
                _buildConfirmButton(controller),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: AppImageViewer(
        imagePath: AppImages.otpPageImage,
        height: 200.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      AppStrings.verifyEmailTitle,
      style: AppTextStyles.titleLarge.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubtitle(ForgotPasswordController controller) {
    return Obx(
      () => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary),
          children: [
            const TextSpan(text: AppStrings.verifyEmailMessagePart1),
            TextSpan(
              text: controller.emailController.value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.interactive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInputs(ForgotPasswordController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 56.w,
          height: 50.w,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: Obx(
            () => TextField(
              focusNode: controller.focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: controller.otpDigits[index].value.isNotEmpty
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: controller.otpDigits[index].value.isNotEmpty
                      ? BorderSide(color: AppColors.primary, width: 1.5.w)
                      : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2.w),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              // onChanged: (value) => controller.updateOtp(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOtpError(ForgotPasswordController controller) {
    return Obx(
      () => controller.otpErrorText.value.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                controller.otpErrorText.value,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildConfirmButton(ForgotPasswordController controller) {
    return Obx(
      () => AppButton(
        text: AppStrings.verifyBtn,
        isLoading: controller.isLoading.value,
        // onPressed: controller.verifyOtp,
      ),
    );
  }
}
