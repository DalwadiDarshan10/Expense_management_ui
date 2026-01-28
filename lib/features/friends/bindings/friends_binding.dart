import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:get/get.dart';

class FriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(() => FriendsController());
  }
}
