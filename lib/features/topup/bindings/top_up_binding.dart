import 'package:expense/features/topup/controllers/top_up_controller.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class TopUpBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure WalletController is available as TopUpController depends on it
    if (!Get.isRegistered<WalletController>()) {
      Get.lazyPut<WalletController>(() => WalletController());
    }
    Get.lazyPut<TopUpController>(() => TopUpController());
  }
}
