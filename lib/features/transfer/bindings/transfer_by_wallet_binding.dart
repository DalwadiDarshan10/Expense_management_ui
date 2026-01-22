import 'package:get/get.dart';
import 'package:expense/features/transfer/controllers/transfer_by_wallet_controller.dart';

class TransferByWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferByWalletController>(() => TransferByWalletController());
  }
}
