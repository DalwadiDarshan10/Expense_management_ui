import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Melvin Guerrero'.obs;
  final RxString userPhone = '505-287-9051'.obs;
  final RxString userAvatar =
      ''.obs; // Empty string triggers initial placeholder
  final RxInt points = 4000.obs;
  final RxDouble balance = 12769.00.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate loading data
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // In a real app, this would fetch from an API or local storage
    userName.value = 'Melvin Guerrero';
    userPhone.value = '505-287-9051';
    points.value = 4000;
    balance.value = 12769.00;
  }

  void logout() {
    // Add logout logic here, e.g., clear tokens, navigate to login
    Get.offAllNamed('/login');
    // For now just print
    debugPrint('User logged out');
  }
}
