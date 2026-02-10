import 'package:expense/features/analytics/controller/share_analysis_controller.dart';
import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:get/get.dart';

class ShareAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(() => FriendsController());
    Get.lazyPut<ShareAnalysisController>(() => ShareAnalysisController());
  }
}
