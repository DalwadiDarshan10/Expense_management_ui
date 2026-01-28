import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  final nameError = Rx<String?>(null);
  final phoneError = Rx<String?>(null);
  final emailError = Rx<String?>(null);

  void validateName(String value) {
    if (value.trim().isEmpty) {
      nameError.value = "Name cannot be empty";
    } else {
      nameError.value = null;
    }
  }

  void validatePhone(String value) {
    final phoneFn = value.trim();
    if (phoneFn.isEmpty) {
      phoneError.value = "Phone number is required";
    } else if (phoneFn.length != 10) {
      phoneError.value =
          null; // Don't show error while typing unless needed, but requirement implies strict 10
      // Actually, for better UX let's show error if length > 0 and != 10 on submit, or live if requested.
      // User asked for live error.
      phoneError.value = "Phone number must be exactly 10 digits";
    } else {
      phoneError.value = null;
    }
  }

  void validatePhoneLive(String value) {
    // Only show error if length is 10 and then user deletes, or if completely empty?
    // User asked for "live error text".
    // Usually we don't show "must be 10 digits" while they are typing digit 1.
    // But let's stick to simple logic: if it's not empty and not 10 digits, it's an error?
    // Or maybe only validate strictly on submit, but clear error on change?
    // Let's implement immediate feedback but maybe check if length > 0.

    if (value.isEmpty) {
      phoneError.value = "Phone number is required";
    } else if (value.length != 10) {
      phoneError.value = "Phone number must be exactly 10 digits";
    } else {
      phoneError.value = null;
    }
  }

  void validateEmail(String value) {
    final emailFn = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailFn.isEmpty) {
      emailError.value = "Email is required";
    } else if (!emailRegex.hasMatch(emailFn)) {
      emailError.value = "Enter a valid email address";
    } else {
      emailError.value = null;
    }
  }

  bool validate() {
    validateName(nameController.text);
    validatePhoneLive(phoneController.text);
    validateEmail(emailController.text);

    return nameError.value == null &&
        phoneError.value == null &&
        emailError.value == null;
  }

  void addFriend() {
    if (validate()) {
      final friendsCtrl = Get.find<FriendsController>();
      friendsCtrl.addFriend(
        FriendModel(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
        ),
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Friend added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
