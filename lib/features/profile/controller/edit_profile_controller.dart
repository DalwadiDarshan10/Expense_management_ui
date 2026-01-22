import 'package:expense/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final ProfileController _profileController = Get.find<ProfileController>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(
      text: _profileController.userName.value,
    );
    phoneController = TextEditingController(
      text: _profileController.userPhone.value,
    );
    // Assuming email is not yet in ProfileController, initializing with empty or placeholder
    emailController = TextEditingController(text: "Unlinked");
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void saveChanges() {
    // TODO: Implement actual save logic (API call)
    _profileController.userName.value = nameController.text;
    _profileController.userPhone.value = phoneController.text;
    // Email update logic if available in ProfileController

    Get.back();
    Get.snackbar(
      "Success",
      "Profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
