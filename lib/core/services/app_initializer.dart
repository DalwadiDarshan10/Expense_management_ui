import 'package:expense/core/localization/language_controller.dart';
import 'package:expense/core/theme/theme_controller.dart';
import 'package:expense/features/profile/controller/security_controller.dart';
import 'package:expense/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Local Storage
    await GetStorage.init();

    // Initialize Global Controllers
    Get.put(LanguageController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(SecurityController(), permanent: true);
  }
}
