import 'package:get/get.dart';

class AppStrings {
  AppStrings._();

  // Common
  static String get login => 'auth.login'.tr;
  static String get cancel => 'common.cancel'.tr;
  static String get delete => 'common.delete'.tr;
  static String get done => 'common.done'.tr;
  static String get save => 'common.save'.tr;
  static String get send => 'common.send'.tr;
  static String get today => 'common.today'.tr;
  static String get yesterday => 'common.yesterday'.tr;
  static String get error => 'common.error'.tr;
  static String get success => 'common.success'.tr;
  static String get skip => 'common.skip'.tr;
  static String get viewAll => 'common.view_all'.tr;
  static String get resultLabel => 'common.result'.tr;
  static String get copiedTitle => 'common.copied'.tr;
  static String get copyLinkBtn => 'common.copy_link'.tr;

  // Voucher Page
  static String get voucherTitle => 'voucher.title'.tr;
  static String get categories => 'voucher.categories'.tr;
  static String get categoryAll => 'voucher.category_all'.tr;
  static String get categoryInternet => 'voucher.category_internet'.tr;
  static String get categoryElectricity => 'voucher.category_electricity'.tr;
  static String get categoryMarket => 'voucher.category_market'.tr;
  static String get categoryMedical => 'voucher.category_medical'.tr;
  static String get topTrendingDeals => 'voucher.top_trending'.tr;
  static String get saleOff50 => 'voucher.sale_off_50'.tr;

  // Deal items
  static String get burgerTitle => 'voucher.burger'.tr;
  static String get burgerDesc => 'voucher.burger_desc'.tr;
  static String get freeship => 'voucher.freeship'.tr;
  static String get sandwichTitle => 'voucher.sandwich'.tr;
  static String get sandwichDesc => 'voucher.sandwich_desc'.tr;
  static String get pizzaHutTitle => 'voucher.pizza_hut'.tr;
  static String get pizzaDesc => 'voucher.pizza_desc'.tr;
  static String get kfcTitle => 'voucher.kfc'.tr;
  static String get kfcDesc => 'voucher.kfc_desc'.tr;
  static String get halfOffBadge => 'voucher.half_off'.tr;
  static String get starbucksTitle => 'voucher.starbucks'.tr;
  static String get coffeeDesc => 'voucher.coffee_desc'.tr;
  static String get noDealsAvailable => 'voucher.no_deals'.tr;
  static String get dealsTitle => 'voucher.deals_title'.tr;

  // Transfer Page
  static String get transferTitle => 'transfer.title'.tr;
  static String get transferByWallet => 'transfer.by_wallet'.tr;
  static String get transferByBank => 'transfer.by_bank'.tr;
  static String get recentTransfer => 'transfer.recent'.tr;
  static String get friends => 'transfer.friends'.tr;

  // Notification Page
  static String get notificationTitle => 'notification.title'.tr;
  static String get deleteNotificationsTitle =>
      'notification.delete_all_title'.tr;
  static String get deleteNotificationsMessage =>
      'notification.delete_all_msg'.tr;
  static String get noNotifications => 'notification.empty'.tr;

  // Add New Card Page
  static String get addNewCardTitle => 'wallet.add_card'.tr;
  static String get cardNumberLabel => 'wallet.card_number'.tr;
  static const String cardNumberHint = "1234 4567 8901 2345";
  static String get expiredLabel => 'wallet.expired'.tr;
  static const String expiredHint = "12/24";
  static String get bankLabel => 'wallet.bank'.tr;
  static String get selectBank => 'wallet.select_bank'.tr;
  static String get cardHolderNameLabel => 'wallet.card_holder'.tr;
  static const String cardHolderNameHint = "Melvin Guerrero";
  static String get btnAddNewCard => 'wallet.add_card'.tr;

  // Login Page (Specific labels)
  static String get emailLabel => 'auth.email'.tr;
  static String get emailHint => 'auth.email_hint'.tr;
  static String get passwordLabel => 'auth.password'.tr;
  static String get passwordHint => 'auth.password_hint'.tr;
  static String get savePassword => 'auth.save_password'.tr;
  static String get forgotPassword => 'auth.forgot_password'.tr;
  static String get loginBtn => 'auth.login_btn'.tr;
  static String get dontHaveAccount => 'auth.dont_have_account'.tr;
  static String get signUp => 'auth.sign_up'.tr;

  // Transfer By Wallet
  static String get transferByWalletTitle => 'transfer.by_wallet_title'.tr;
  static String get cashLabel => 'transfer.cash'.tr;
  static const String cashHintWallet = "\$ 12,000.00";
  static String get transferContentLabel => 'transfer.content'.tr;
  static String get transferContentHint => 'transfer.content_hint'.tr;
  static String get greetingCards => 'transfer.greeting_cards'.tr;
  static String get swipeToTransfer => 'transfer.swipe_to_transfer'.tr;

  // Transfer By Bank
  static String get transferByBankTitle => 'transfer.by_bank_title'.tr;
  static String get toTheAccountLabel => 'transfer.to_account'.tr;
  static const String toTheAccountHint = "122 456 141 250";
  static const String cashHintBank = "\$ 12.00.00";

  // Register Page
  static String get registerTitle => 'auth.register'.tr;
  static String get usernameLabel => 'friends.full_name'.tr;
  static const String usernameHint = "Melvin Guerrero";
  static String get passwordHintShort => 'auth.password_hint_short'.tr;
  static String get confirmPasswordLabel => 'auth.confirm_password'.tr;
  static String get termsPart1 => 'auth.terms_part1'.tr;
  static String get termsPart2 => 'auth.terms_part2'.tr;
  static String get alreadyHaveAccount => 'auth.already_have_account'.tr;

  // Forgot Password Page
  static String get forgotPasswordTitle => 'auth.forgot_password_title'.tr;
  static String get forgotPasswordMessage => 'auth.forgot_password_msg'.tr;
  static String get sendOtpBtn => 'auth.send_otp'.tr;

  // Reset Password Page
  static String get resetPasswordTitle => 'auth.reset_password'.tr;
  static String get createNewPassword => 'auth.create_new_password'.tr;
  static String get createNewPasswordMessage =>
      'auth.create_new_password_msg'.tr;
  static String get newPasswordLabel => 'auth.new_password'.tr;
  static String get confirmPasswordLabelMatches =>
      'auth.confirm_password_match'.tr;
  static String get confirmPasswordHintMatches =>
      'auth.confirm_password_hint_match'.tr;
  static String get resetPasswordBtn => 'auth.reset_password'.tr;

  // Verify Email OTP Page
  static String get verificationTitle => 'auth.verification'.tr;
  static String get verifyEmailTitle => 'auth.verify_email'.tr;
  static String get verifyEmailMessagePart1 => 'auth.verify_msg_part1'.tr;
  static String get verifyBtn => 'auth.verify_btn'.tr;

  // Onboarding Page
  static String get appName => 'onboarding.app_name'.tr;
  static String get onboardingMessage => 'onboarding.message'.tr;
  static String get getStartedBtn => 'onboarding.get_started'.tr;

  // Signup Successful Page
  static String get signupSuccessfulTitle => 'auth.signup_success'.tr;
  static String get signupSuccessfulMessage => 'auth.signup_success_msg'.tr;
  static String get doneBtn => 'common.done'.tr;

  // Home Page
  static String get balance => 'home.balance'.tr;
  static String get topUp => 'home.top_up'.tr;
  static String get wallet => 'home.wallet'.tr;
  static String get qrScan => 'home.qr_scan'.tr;
  static String get myQr => 'home.my_qr'.tr;
  static String get sendAgain => 'home.send_again'.tr;
  static String get paymentList => 'home.payment_list'.tr;
  static String get tradingHistory => 'home.trading_history'.tr;
  static String get sent => 'common.send'.tr;
  static String get electricBillTitle => 'home.electric_bill'.tr;
  static String get televisionBillTitle => 'home.television'.tr;

  // Payment Items
  static String get insurance => 'home.insurance'.tr;
  static String get electricBill => 'home.electric_bill'.tr;
  static String get television => 'home.television'.tr;
  static String get waterBill => 'home.water_bill'.tr;

  // Wallets Dashboard
  static String get myWallet => 'wallet.my_wallet'.tr;
  static String get deleteCardTitle => 'wallet.delete_card_title'.tr;
  static String get deleteCardMessage => 'wallet.delete_card_msg'.tr;
  static String get withdraw => 'wallet.withdraw'.tr;
  static String get history => 'wallet.history'.tr;

  // Top Up Page
  static String get topUpTitle => 'wallet.top_up'.tr;
  static String get denominations => 'wallet.denominations'.tr;
  static String get noCardsAvailable => 'wallet.no_cards'.tr;

  // Withdraw Page
  static String get withdrawTitle => 'withdraw.title'.tr;
  static String get withdrawToAviBank => 'withdraw.to_avi_bank'.tr;
  static String get swipeToWithdraw => 'withdraw.swipe_to_withdraw'.tr;
  static String get enterAmountHint => 'withdraw.enter_amount'.tr;

  // QR Scanner Page
  static String get flashlight => 'qr.flashlight'.tr;
  static String get switchToBarcode => 'qr.switch_to_barcode'.tr;
  static String get switchToQrCode => 'qr.switch_to_qr'.tr;

  // My QR Page
  static String get couponLabel => 'qr.coupon'.tr;
  static const String couponHint = "Your coupon";
  static String get usePointsLabel => 'qr.use_points'.tr;

  // Share Bill Page
  static String get shareBillTitle => 'share_bill.title'.tr;
  static String get sharedWithTitle => 'share_bill.shared_with'.tr;
  static String get phoneNumberHint => 'friends.phone_number'.tr;
  static String get sendBtn => 'common.send'.tr;
  static String get sentSuccessTitle => 'common.send'.tr;
  static String get sentSuccessMessage => 'share_bill.sent_success'.tr;
  static String get errorTitle => 'common.error'.tr;
  static String get enterPhoneError => 'share_bill.enter_phone_error'.tr;
  static String get noContactsFound => 'friends.no_contacts'.tr;
  static String get learnSharing => 'share_bill.learn_sharing'.tr;
  static String get copiedMessage => 'common.copied'.tr;

  // Add Friend Page
  static String get addNewFriendTitle => 'friends.add_friend'.tr;
  static String get fullNameLabel => 'friends.full_name'.tr;
  static const String fullNameHint = "Enter full name";
  static String get phoneNumberLabel => 'friends.phone_number'.tr;
  static const String enterPhoneNumberHint = "Enter phone number";
  static const String enterEmailHint = "Enter email address";
  static String get addNewContactBtn => 'friends.add_contact_btn'.tr;

  // Profile Page
  static String get profileTitle => 'profile.title'.tr;
  static String get cardsBankAccounts => 'profile.cards_bank'.tr;
  static String get manageGroupFriends => 'profile.manage_friends'.tr;
  static String get paymentSecurity => 'profile.payment_security'.tr;
  static String get settingTitle => 'profile.setting'.tr;
  static String get logoutBtn => 'profile.logout'.tr;

  // Edit Profile Page
  static String get editProfileTitle => 'profile.edit_profile'.tr;
  static String get saveChangeBtn => 'profile.save_changes'.tr;

  // Setting Page
  static String get changeFaceId => 'settings.change_face_id'.tr;
  static String get changeLanguage => 'settings.change_language'.tr;
  static String get changePassword => 'settings.change_password'.tr;
  static String get otherLabel => 'settings.other'.tr;
  static String get applicationInformation => 'settings.app_info'.tr;

  // Change Password Page
  static String get oldPasswordLabel => 'auth.password'.tr;
  static const String oldPasswordHint = "Walletavipay123";
  static String get newPasswordLabel8Chars => 'auth.new_password'.tr;
  static String get passwordHint8Chars => 'auth.password_hint'.tr;
  static const String signOutOfAllDevices = "Sign Out Of All Devices";

  // Payment Security Page
  static String get appLockedTitle => 'security.app_locked'.tr;
  static String get sessionExpiredMessage => 'security.session_expired'.tr;
  static String get transferLimit => 'security.transfer_limit'.tr;
  static String get transactionLimit => 'security.transaction_limit'.tr;
  static String get appAutoLocks => 'security.auto_lock'.tr;
  static String get screenLockTime => 'security.screen_lock_time'.tr;
  // Time Options
  static String get time30Sec => 'security.time_30_sec'.tr;
  static String get time1Min => 'security.time_1_min'.tr;
  static String get time2Min => 'security.time_2_min'.tr;
  static String get time3Min => 'security.time_3_min'.tr;
  static String get time5Min => 'security.time_5_min'.tr;

  // Analytics Page
  static String get analyticsTitle => 'analytics.title'.tr;
  static String get incomeLabel => 'analytics.income'.tr;
  static String get outcomeLabel => 'analytics.outcome'.tr;

  // Share Analysis Page
  static String get shareAnalysisTitle => 'analytics.share'.tr;

  // Face ID Page
  static String get faceIdTitle => 'face_id.title'.tr;
  static String get faceRecognition => 'face_id.recognition'.tr;
  static String get faceRecognitionMessage => 'face_id.msg'.tr;
  static String get scanMyFace => 'face_id.scan_btn'.tr;
  static String get skipBtn => 'common.skip'.tr;
  static String get images => 'common.view_all'.tr;

  // Application Info Page
  static String get version => 'info.version'.tr;
  static String get developer => 'info.developer'.tr;
  static String get privacyPolicy => 'info.privacy'.tr;
  static String get termsOfService => 'info.terms'.tr;
  static String get contact => 'info.contact'.tr;

  // Additional New Keys
  static String get noTransactions => 'common.no_transactions'.tr;
  static String get cameraPermission => 'face_id.camera_permission'.tr;
  static String get openSettings => 'face_id.open_settings'.tr;

  // Even More Keys
  static String get noRecentTransfers => 'transfer.no_recent'.tr;
  static String get myAccounts => 'wallet.my_accounts'.tr;
  static String get totalBalance =>
      'home.balance'.tr; // Reusing balance for now or add home.total_balance
}
