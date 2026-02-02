import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Get the current theme mode from storage
  ThemeMode get themeMode {
    if (_loadThemeFromBox()) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  /// Load the theme status from local storage
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  /// Save the theme status to local storage
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Switch the theme and save the preference
  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      _saveThemeToBox(false);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      _saveThemeToBox(true);
    }
  }
}
