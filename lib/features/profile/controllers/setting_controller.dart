import 'package:expense/core/localization/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final LanguageController _languageController = Get.find<LanguageController>();

  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'flag': '🇺🇸', 'locale': const Locale('en', 'US')},
    {'name': 'हिंदी', 'flag': '🇮🇳', 'locale': const Locale('hi', 'IN')},
    {'name': 'ગુજરાતી', 'flag': '🇮🇳', 'locale': const Locale('gu', 'IN')},
  ];

  late RxString selectedLanguage;
  late RxString selectedFlag;

  @override
  void onInit() {
    super.onInit();
    final currentLocale = _languageController.locale;
    final currentLang = languages.firstWhere(
      (element) => element['locale'] == currentLocale,
      orElse: () => languages.first,
    );
    selectedLanguage = (currentLang['name'] as String).obs;
    selectedFlag = (currentLang['flag'] as String).obs;
  }

  void changeLanguage(String name, String flag, Locale locale) {
    selectedLanguage.value = name;
    selectedFlag.value = flag;
    _languageController.changeLanguage(locale);
    Get.back(); // Close the bottom sheet
  }
}
