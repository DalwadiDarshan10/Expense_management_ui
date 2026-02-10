import 'package:expense/features/auth/bindings/forget_password_bindings.dart';
import 'package:expense/features/auth/bindings/login_binding.dart';
import 'package:expense/features/auth/bindings/register_binding.dart';
import 'package:expense/features/auth/pages/forget_password.dart';
import 'package:expense/features/auth/pages/login_page.dart';
import 'package:expense/features/auth/pages/onboarding_page.dart';
import 'package:expense/features/auth/pages/register_page.dart';
import 'package:expense/features/auth/pages/signup_sucessfull_page.dart';
import 'package:expense/features/home/pages/main_navigation_page.dart';
import 'package:expense/features/qr/bindings/qr_binding.dart';
import 'package:expense/features/qr/bindings/share_qr_binding.dart';
import 'package:expense/features/qr/pages/my_qr_page.dart';
import 'package:expense/features/qr/pages/qr_scanner_page.dart';
import 'package:expense/features/qr/pages/share_qr_page.dart';
import 'package:expense/features/bill/bindings/share_bill_binding.dart';
import 'package:expense/features/bill/pages/share_bill_page.dart';
import 'package:expense/features/topup/bindings/top_up_binding.dart';
import 'package:expense/features/topup/pages/top_up_page.dart';
import 'package:expense/features/withdraw/binding/withdraw_binding.dart';
import 'package:expense/features/withdraw/pages/withdraw_page.dart';
import 'package:expense/features/wallet/bindings/wallet_binding.dart';
import 'package:expense/features/wallet/pages/add_new_card_page.dart';
import 'package:expense/features/wallet/pages/wallets_dashboard_page.dart';
import 'package:expense/features/transfer/bindings/transfer_binding.dart';
import 'package:expense/features/transfer/bindings/transfer_by_bank_binding.dart';
import 'package:expense/features/transfer/bindings/transfer_by_wallet_binding.dart';
import 'package:expense/features/transfer/pages/transfer_by_bank_page.dart';
import 'package:expense/features/transfer/pages/transfer_by_wallet_page.dart';
import 'package:expense/features/profile/bingings/edit_profile_binding.dart';
import 'package:expense/features/profile/pages/edit_profile_page.dart';
import 'package:expense/features/profile/pages/payment_security_page.dart';
import 'package:expense/features/profile/pages/setting_page.dart';
import 'package:expense/features/analytics/bingings/share_analysis_binding.dart';
import 'package:expense/features/analytics/pages/share_analysis_page.dart';
import 'package:expense/features/notification/pages/notification_page.dart';
import 'package:expense/features/transfer/pages/transfer_page.dart';
import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/friends/bindings/friends_binding.dart';
import 'package:expense/features/friends/pages/friends_page.dart';
import 'package:expense/features/friends/bindings/add_friend_binding.dart';
import 'package:expense/features/friends/pages/add_friend_page.dart';
import 'package:expense/features/transfer/pages/recent_transfers_page.dart';
import 'package:expense/features/voucher/pages/voucher_deals_page.dart';
import 'package:expense/features/bill/bindings/utility_bill_binding.dart';
import 'package:expense/features/bill/pages/service_provider_selection_page.dart';
import 'package:expense/features/bill/pages/bill_details_page.dart';
import 'package:expense/features/analytics/pages/all_transactions_page.dart';
import 'package:expense/features/profile/pages/pin_setup_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initial = '/';

  static final List<GetPage> routes = [
    GetPage(name: AppNamed.onboarding, page: () => const OnboardingPage()),
    GetPage(
      name: AppNamed.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppNamed.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppNamed.signupSuccess,
      page: () => const SignupSuccessfulPage(),
    ),
    GetPage(
      name: AppNamed.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    // GetPage(
    //   name: AppNamed.resetPassword,
    //   page: () => const ResetPasswordPage(),
    // ),
    GetPage(name: AppNamed.menuPage, page: () => MainNavigationPage()),
    GetPage(
      name: AppNamed.walletsDashboard,
      page: () => const WalletsDashboardPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppNamed.addNewCard,
      page: () => const AddNewCardPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppNamed.topUpPage,
      page: () => const TopUpPage(),
      binding: TopUpBinding(),
    ),
    GetPage(
      name: AppNamed.withdrawPage,
      page: () => const WithdrawPage(),
      binding: WithdrawBinding(),
    ),
    GetPage(
      name: AppNamed.scannerPage,
      page: () => const QrScannerPage(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: AppNamed.myQrPage,
      page: () => const MyQrPage(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: AppNamed.transferPage,
      page: () => const TransferPage(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: AppNamed.transferByWalletPage,
      page: () => const TransferByWalletPage(),
      binding: TransferByWalletBinding(),
    ),
    GetPage(
      name: AppNamed.transferByBankPage,
      page: () => const TransferByBankPage(),
      binding: TransferByBankBinding(),
    ),
    GetPage(
      name: AppNamed.editProfile,
      page: () => const EditProfilePage(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppNamed.paymentSecurity,
      page: () => const PaymentSecurityPage(),
    ),
    GetPage(name: AppNamed.setting, page: () => const SettingPage()),
    GetPage(
      name: AppNamed.notificationPage,
      page: () => const NotificationPage(),
    ),
    GetPage(
      name: AppNamed.shareAnalysis,
      page: () => const ShareAnalysisPage(),
      binding: ShareAnalysisBinding(),
    ),
    GetPage(
      name: AppNamed.shareQr,
      page: () => const ShareQrPage(),
      binding: ShareQrBinding(),
    ),
    GetPage(
      name: AppNamed.shareBill,
      page: () => const ShareBillPage(),
      binding: ShareBillBinding(),
    ),
    GetPage(
      name: AppNamed.friends,
      page: () => const FriendsPage(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: AppNamed.addNewFriend,
      page: () => const AddFriendPage(),
      binding: AddFriendBinding(),
    ),
    GetPage(
      name: AppNamed.transactionSuccess,
      page: () => const TransactionSuccessPage(),
    ),
    GetPage(name: AppNamed.voucherDeals, page: () => const VoucherDealsPage()),
    GetPage(
      name: AppNamed.recentTransfers,
      page: () => const RecentTransfersPage(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: AppNamed.utilityBills,
      page: () => const ServiceProviderSelectionPage(),
      binding: UtilityBillBinding(),
    ),
    GetPage(
      name: AppNamed.billDetails,
      page: () => const BillDetailsPage(),
      binding: UtilityBillBinding(),
    ),
    GetPage(
      name: AppNamed.allTransactions,
      page: () => const AllTransactionsPage(),
    ),
    GetPage(name: AppNamed.pinSetup, page: () => const PinSetupPage()),
  ];
}
