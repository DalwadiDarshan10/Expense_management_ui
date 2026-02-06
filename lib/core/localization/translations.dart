import 'package:get/get.dart';
import 'languages/en_us.dart';
import 'languages/hi_in.dart';
import 'languages/gu_in.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'hi_IN': hiIn,
    'gu_IN': guIn,
  };
}
