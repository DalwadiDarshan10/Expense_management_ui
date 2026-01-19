import 'package:expense/features/auth/bindings/login_binding.dart';
import 'package:expense/features/auth/bindings/register_binding.dart';
import 'package:expense/features/auth/bindings/verify_phone_binding.dart';
import 'package:expense/features/auth/pages/forget_password.dart';
import 'package:expense/features/auth/pages/login_page.dart';
import 'package:expense/features/auth/pages/onboarding_page.dart';
import 'package:expense/features/auth/pages/register_page.dart';
import 'package:expense/features/auth/pages/signup_sucessfull_page.dart';
import 'package:expense/features/home/pages/menu_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initial = '/';

  static final List<GetPage> routes = [
    GetPage(name: AppNamed.onboarding, page: () => const OnboardingPage()),
    GetPage(
      name: AppNamed.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppNamed.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppNamed.signupSuccess,
      page: () => const SignupSuccessfulPage(),
    ),
    GetPage(
      name: AppNamed.verifyPhone,
      page: () => const VerifyPhonePage(),
      binding: VerifyPhoneBinding(),
    ),
    GetPage(name: AppNamed.menuPage, page: () => const MenuPage()),
  ];
}
