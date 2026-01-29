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
  final RxDouble balance = 12769.00.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = _authService.currentUser;
    if (user != null) {
      // Load data from Firebase Auth
      userName.value = user.displayName ?? 'No Name';
      userEmail.value = user.email ?? 'No Email';
      userPhone.value =
          user.phoneNumber ?? _storage.read('userPhone') ?? 'No Phone';
      userAvatar.value = _storage.read('userAvatarPath') ?? '';

      // Load additional data from storage if available
      points.value = _storage.read('userPoints') ?? 4000;
      balance.value = _storage.read('userBalance') ?? 12769.00;
    } else {
      debugPrint('No user logged in');
    }
  }

  void refreshProfile() {
    _loadUserProfile();
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
      debugPrint('Logout error: $e');
      Get.snackbar('Error', 'Failed to logout');
    }
  }
}
