import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:expense/features/friends/models/friend_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddFriendController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

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

  void validatePhoneLive(String value) {
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

  Future<void> addFriend() async {
    if (validate()) {
      try {
        final friendsCtrl = Get.find<FriendsController>();
        final newFriend = FriendModel(
          id: _uuid.v4(),
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
        );

        await friendsCtrl.addFriendToFirestore(newFriend);

        Get.back();
        Get.snackbar(
          'Success',
          'Friend added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to add friend: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
