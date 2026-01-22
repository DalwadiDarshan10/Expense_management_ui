import 'package:get/get.dart';
import 'package:expense/features/transfer/controllers/transfer_by_bank_controller.dart';

class TransferByBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferByBankController>(() => TransferByBankController());
  }
}
