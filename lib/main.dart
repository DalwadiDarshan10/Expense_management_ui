import 'package:expense/firebase_options.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final bool isLoggedIn = box.read('isLoggedIn') ?? false;

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size (iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedIn ? AppNamed.menuPage : AppNamed.onboarding,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
