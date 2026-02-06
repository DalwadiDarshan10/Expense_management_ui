import 'package:expense/core/localization/language_controller.dart';
import 'package:expense/core/localization/translations.dart';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/core/theme/theme_controller.dart';
import 'package:expense/firebase_options.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(LanguageController());
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final bool isLoggedIn = box.read('isLoggedIn') ?? false;
    final languageController = Get.find<LanguageController>();

    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size (iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            translations: AppTranslations(),
            locale: languageController.locale,
            fallbackLocale: const Locale('en', 'US'),
            initialRoute: isLoggedIn ? AppNamed.menuPage : AppNamed.onboarding,
            getPages: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
