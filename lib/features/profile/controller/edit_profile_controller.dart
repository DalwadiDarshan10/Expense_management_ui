import 'dart:io';
import 'package:expense/features/auth/services/auth_service.dart';
import 'package:expense/features/profile/controller/profile_controller.dart';
import 'package:expense/features/profile/services/image_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();
  final ImageStorageService _imageStorageService = ImageStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final RxBool isLoading = false.obs;
  final RxBool isUploadingImage = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(
      text: profileController.userName.value,
    );
    phoneController = TextEditingController(
      text: profileController.userPhone.value,
    );
    emailController = TextEditingController(
      text: profileController.userEmail.value,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveChanges() async {
    try {
      // Upload image first if selected
      if (selectedImage.value != null) {
        isUploadingImage.value = true;
        final userId = _authService.currentUser?.uid;

        if (userId != null) {
          try {
            debugPrint('Starting local image save for user: $userId');
            final imagePath = await _imageStorageService.uploadProfileImage(
              selectedImage.value!,
              userId,
            );
            debugPrint('Image saved locally. Path: $imagePath');

            // Save path to GetStorage
            _storage.write('userAvatarPath', imagePath);
            profileController.userAvatar.value = imagePath;
            debugPrint('Profile photo path saved to storage');

            Get.snackbar(
              "Success",
              "Profile photo updated successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
            );
          } catch (e) {
            debugPrint('Image save error: $e');
            Get.snackbar(
              "Upload Failed",
              "Error: $e",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 5),
            );
            isUploadingImage.value = false;
            return; // Stop execution if image save fails
          }
        } else {
          Get.snackbar(
            "Error",
            "User not logged in",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isUploadingImage.value = false;
          return;
        }
        isUploadingImage.value = false;
      }

      // Update display name in Firebase if changed
      if (nameController.text != profileController.userName.value) {
        await _authService.updateDisplayName(nameController.text);
        profileController.userName.value = nameController.text;
        _storage.write('username', nameController.text);
      }

      // Update phone number in storage (Firebase doesn't directly support phone updates)
      if (phoneController.text != profileController.userPhone.value) {
        profileController.userPhone.value = phoneController.text;
        _storage.write('userPhone', phoneController.text);
      }

      // Note: Email updates require verification and are handled separately
      // For now, we'll just show a message if email is changed
      if (emailController.text != profileController.userEmail.value) {
        Get.snackbar(
          "Email Update",
          "Email updates require verification. This feature will be available soon.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      // Refresh profile to reflect changes
      profileController.refreshProfile();

      Get.back();
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Save changes error: $e');
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }
}
