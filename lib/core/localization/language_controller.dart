import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'language';

  // Supported Locales
  static const List<Map<String, dynamic>> locales = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
    {'name': 'ગુજરાતી', 'locale': Locale('gu', 'IN')},
  ];

  Locale get locale {
    String? langCode = _box.read(_key);
    if (langCode != null) {
      if (langCode == 'hi_IN') return const Locale('hi', 'IN');
      if (langCode == 'gu_IN') return const Locale('gu', 'IN');
    }
    return Get.deviceLocale ?? const Locale('en', 'US');
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
    _box.write(_key, '${locale.languageCode}_${locale.countryCode}');
    update();
  }

  String get currentLanguageName {
    Locale active = locale;
    for (var item in locales) {
      Locale l = item['locale'];
      if (l.languageCode == active.languageCode &&
          l.countryCode == active.countryCode) {
        return item['name'];
      }
    }
    return 'English';
  }
}
