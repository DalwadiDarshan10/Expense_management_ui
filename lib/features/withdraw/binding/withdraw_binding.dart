import 'package:expense/features/withdraw/controllers/withdraw_controller.dart';
import 'package:get/get.dart';

class WithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawController>(() => WithdrawController());
  }
}
