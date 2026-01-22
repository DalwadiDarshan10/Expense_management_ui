import 'package:get/get.dart';
import 'package:expense/features/transfer/models/contact_model.dart';
import 'package:expense/routes/app_named.dart';

class TransferController extends GetxController {
  final recentContacts = <ContactModel>[].obs;
  final friends = <ContactModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    recentContacts.addAll([
      ContactModel(name: 'Irene Perry', phone: '505-287-8051'),
      ContactModel(name: 'Casey Bourn', phone: '518-778-0800'),
      ContactModel(name: 'Jane Holden', phone: '414-586-7314'),
      ContactModel(name: 'Conrad Ford', phone: '+0123456789'),
    ]);

    friends.addAll([
      ContactModel(name: 'Jackson Soto', phone: '505-287-8051'),
      ContactModel(name: 'Alfred Neal', phone: '505-287-8051'),
    ]);
  }

  void onTransferByWallet() {
    Get.toNamed(AppNamed.transferByWalletPage);
  }

  void onTransferByBank() {
    Get.toNamed(AppNamed.transferByBankPage);
  }

  void onContactSelected(ContactModel contact) {
    Get.toNamed(AppNamed.transferByWalletPage, arguments: contact);
  }
}
