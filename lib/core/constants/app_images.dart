/// App Images - Contains all image paths used in the application
///
/// Usage with AppImageViewer:
/// ```dart
/// AppImageViewer(
///   imagePath: AppImages.logo,
///   height: 100,
///   width: 100,
/// )
/// ```
class AppImages {
  // Private constructor to prevent instantiation
  AppImages._();

  // Base paths
  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';
  static const String _logoPath = "assets/logos";

  // App Logo
  static const String appLogo = '$_logoPath/app_logo.svg';

  // Onboarding Images
  static const String onboardingImage1 =
      '$_imagePath/onboarding_page_image.svg';
  static const String otpPageImage = '$_imagePath/otp_page_image.svg';
  static const String signUpSucessfullImage =
      '$_imagePath/signup_sucessfull_image.svg';

  // // Icons (SVG)
  static const String hideImage = '$_iconPath/password_hide_icon.svg';
  static const String showImage = '$_iconPath/password_show_icon.svg';
  static const String greentick = '$_iconPath/green_tick_icon.svg';

  // Menu Page Icons
  static const String topupIcon = '$_iconPath/topup_icon.svg';
  static const String walletIcon = '$_iconPath/Wallet_icon.svg';
  static const String scanIcon = '$_iconPath/scan_icon.svg';
  static const String myQrcodeIcon = '$_iconPath/my_qrcode_icon.svg';
  static const String notificationIcon = '$_iconPath/Notification.svg';

  // Payment Badge Images
  static const String electricityBadge =
      '$_imagePath/electricity_badge_image.svg';
  static const String internetBadge = '$_imagePath/internate_badge_image.svg';
  static const String insuranceBadge = '$_imagePath/insurrance_badge_image.svg';
  static const String medicalBadge = '$_imagePath/medical_badge_image.svg';
  static const String marketBadge = '$_imagePath/market_badge_image.svg';
  static const String electricBillBadge =
      '$_imagePath/electricbill_badges_image.svg';
  static const String televisionBadge = '$_imagePath/televisio_badge_image.svg';
  static const String waterbillBadge = '$_imagePath/waterbill_badge_image.svg';
  static const String menuPageBackground = '$_imagePath/menu_page_bgimage.svg';
}
