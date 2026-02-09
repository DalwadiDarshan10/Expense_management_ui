import 'package:expense/features/qr/controller/share_qr_controller.dart';
import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:get/get.dart';

class ShareQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(() => FriendsController());
    Get.lazyPut<ShareQrController>(() => ShareQrController());
  }
}
