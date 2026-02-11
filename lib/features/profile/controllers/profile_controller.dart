import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/core/utils/app_logger.dart';
import 'package:expense/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userAvatar = ''.obs;
  final RxInt points = 4000.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxDouble transactionLimit = 200.0.obs;
  final RxBool isTransactionLimitEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
    fetchWalletBalance();
  }

  void _loadUserProfile() async {
    final user = _authService.currentUser;
    if (user != null) {
      // Load data from Firebase Auth
      userName.value = user.displayName ?? 'No Name';
      userEmail.value = user.email ?? 'No Email';

      try {
        // Fetch from Firestore
        final doc = await FirestoreService.userDoc().get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          userPhone.value = data['phone'] ?? '';
          userName.value = data['username'] ?? userName.value;
          // Note: We prioritize Firestore name if available, else Auth name
        } else {
          // Fallback to local storage or auth if no firestore doc
          userPhone.value =
              user.phoneNumber ?? _storage.read('userPhone') ?? 'No Phone';
        }
      } catch (e) {
        AppLogger.error('Error fetching user profile from Firestore: $e');
        // Fallback on error
        userPhone.value =
            user.phoneNumber ?? _storage.read('userPhone') ?? 'No Phone';
      }

      userAvatar.value = _storage.read('userAvatarPath') ?? '';

      // Load additional data from storage if available
      points.value = _storage.read('userPoints') ?? 4000;
      transactionLimit.value = _storage.read('transactionLimit') ?? 200.0;
      isTransactionLimitEnabled.value =
          _storage.read('isTransactionLimitEnabled') ?? true;
    } else {
      AppLogger.warning('No user logged in');
    }
  }

  /// FETCH WALLET BALANCE (REAL-TIME)
  void fetchWalletBalance() {
    try {
      final uid = FirestoreService.uid;
      final path = 'users/$uid/wallet/main';
      AppLogger.info("Listening to wallet balance at: $path");

      FirestoreService.userDoc()
          .collection('wallet')
          .doc('main')
          .snapshots()
          .listen((snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data();
              AppLogger.info("Snapshot found! Data: $data");
              walletBalance.value =
                  (data?['balance'] as num?)?.toDouble() ?? 0.0;
              AppLogger.info("Wallet balance updated: ${walletBalance.value}");
            } else {
              AppLogger.warning("Snapshot DOES NOT exist at: $path");
              // Temporary Debug Snackbar
              // Get.snackbar(
              //   "Debug: No Wallet Found",
              //   "Please Top Up to create wallet.\nPath: $path",
              //   snackPosition: SnackPosition.TOP,
              //   duration: const Duration(seconds: 10),
              //   backgroundColor: Colors.red,
              //   colorText: Colors.white,
              // );
            }
          }, onError: (e) {});
    } catch (e, s) {
      AppLogger.error("Error setting up wallet balance fetch", e, s);
    }
  }

  void refreshProfile() {
    _loadUserProfile();
  }

  void updateTransactionLimit(double limit) {
    transactionLimit.value = limit;
    _storage.write('transactionLimit', limit);
    AppLogger.info("Transaction limit updated to: $limit");
  }

  void toggleTransactionLimit(bool isEnabled) {
    isTransactionLimitEnabled.value = isEnabled;
    _storage.write('isTransactionLimitEnabled', isEnabled);
    AppLogger.info("Transaction limit enabled: $isEnabled");
  }

  void logout() async {
    try {
      await _authService.signOut();
      // Clear storage
      _storage.remove('isLoggedIn');
      _storage.remove('userEmail');
      _storage.remove('username');
      _storage.remove('userPhone');

      Get.offAllNamed('/login');
    } catch (e) {
      AppLogger.error('Logout error: $e');
      Get.snackbar('Error', 'Failed to logout');
    }
  }
}
