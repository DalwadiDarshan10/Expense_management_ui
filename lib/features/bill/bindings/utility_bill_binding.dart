import 'package:expense/features/bill/controller/utility_bill_controller.dart';
import 'package:get/get.dart';

class UtilityBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UtilityBillController>(() => UtilityBillController());
  }
}
