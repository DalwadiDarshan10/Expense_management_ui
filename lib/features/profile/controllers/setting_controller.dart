import 'package:get/get.dart';

class SettingController extends GetxController {
  final selectedLanguage = 'English'.obs;
  final selectedFlag = '🇬🇧'.obs;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'flag': '🇬🇧'},
    {'name': 'Indonesia', 'flag': '🇮🇩'},
    {'name': 'Arabic', 'flag': '🇸🇦'},
    {'name': 'Chinese', 'flag': '🇨🇳'},
    {'name': 'Dutch', 'flag': '🇳🇱'},
    {'name': 'French', 'flag': '🇫🇷'},
    {'name': 'German', 'flag': '🇩🇪'},
    {'name': 'Hindi', 'flag': '🇮🇳'},
    {'name': 'Italian', 'flag': '🇮🇹'},
    {'name': 'Japanese', 'flag': '🇯🇵'},
    {'name': 'Korean', 'flag': '🇰🇷'},
    {'name': 'Portuguese', 'flag': '🇵🇹'},
    {'name': 'Russian', 'flag': '🇷🇺'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'Turkish', 'flag': '🇹🇷'},
    {'name': 'Vietnamese', 'flag': '🇻🇳'},
  ];

  void changeLanguage(String language, String flag) {
    selectedLanguage.value = language;
    selectedFlag.value = flag;
    Get.back(); // Close the bottom sheet
  }
}
