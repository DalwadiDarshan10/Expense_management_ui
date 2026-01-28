import 'package:expense/features/bill/controller/share_bill_controller.dart';
import 'package:get/get.dart';

class ShareBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareBillController>(() => ShareBillController());
  }
}
