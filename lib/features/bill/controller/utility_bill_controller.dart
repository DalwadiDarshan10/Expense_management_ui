import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_text_styles.dart';

class UtilityBillController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final WalletController _walletController = Get.find<WalletController>();

  final RxList<String> providers = <String>[].obs;
  final RxBool isLoading = false.obs;

  // New state for payment source
  final RxBool isWalletSelected = true.obs;
  final RxInt selectedBankIndex = 0.obs;

  // Form fields
  final RxString selectedCategory = ''.obs;
  final RxString selectedProvider = ''.obs;
  final RxString selectedMonth = 'January'.obs;
  final RxString selectedYear = '2024'.obs;
  final RxDouble amount = 0.0.obs;
  final RxString description = ''.obs;

  // Helpers for UI
  double get currentBalance => isWalletSelected.value
      ? _walletController.walletBalance.value
      : selectedBankBalance;

  double get selectedBankBalance {
    if (_walletController.savedBankAccounts.isEmpty) return 0.0;
    if (selectedBankIndex.value >= _walletController.savedBankAccounts.length) {
      return 0.0;
    }
    final bank = _walletController.savedBankAccounts[selectedBankIndex.value];
    return (bank['balance'] as num?)?.toDouble() ?? 0.0;
  }

  Map<String, dynamic>? get selectedBank =>
      _walletController.savedBankAccounts.isNotEmpty &&
          selectedBankIndex.value < _walletController.savedBankAccounts.length
      ? _walletController.savedBankAccounts[selectedBankIndex.value]
      : null;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = ['2023', '2024', '2025', '2026'];

  void setCategory(String category) {
    selectedCategory.value = category;
    _loadProviders(category);
  }

  Future<void> _loadProviders(String category) async {
    isLoading.value = true;
    providers.clear();
    try {
      final snapshot = await _firestore
          .collection('utility_providers')
          .where('category', isEqualTo: category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<String> fetchedProviders = [];
        for (var doc in snapshot.docs) {
          if (doc.data().containsKey('names')) {
            fetchedProviders.addAll(List<String>.from(doc.data()['names']));
          } else if (doc.data().containsKey('name')) {
            fetchedProviders.add(doc.data()['name'] as String);
          }
        }
        providers.assignAll(fetchedProviders);
      } else {
        // Fallback if collection is empty
        _loadFallbackProviders(category);
      }
    } catch (e) {
      // Fallback on permission denied or other errors
      _loadFallbackProviders(category);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payBill() async {
    if (selectedProvider.value.isEmpty || amount.value <= 0) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final double billAmount = amount.value;

      if (currentBalance < billAmount) {
        Get.snackbar('Error', 'Insufficient balance');
        return;
      }

      final userDoc = FirestoreService.userDoc();
      final txnRef = userDoc.collection('transactions').doc();

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        if (isWalletSelected.value) {
          final walletRef = userDoc.collection('wallet').doc('main');
          final walletSnap = await transaction.get(walletRef);
          if (!walletSnap.exists) throw Exception("Wallet not found");

          final num currentBal = walletSnap['balance'] ?? 0.0;
          transaction.update(walletRef, {"balance": currentBal - billAmount});
        } else {
          final bankId = selectedBank?['id'];
          if (bankId == null) throw Exception("Bank account not found");

          final bankRef = userDoc.collection('bankAccounts').doc(bankId);
          final bankSnap = await transaction.get(bankRef);
          if (!bankSnap.exists) throw Exception("Bank account not found");

          final num currentBal = bankSnap['balance'] ?? 0.0;
          transaction.update(bankRef, {"balance": currentBal - billAmount});
        }

        // Record History
        transaction.set(txnRef, {
          'type': 'bill',
          'amount': billAmount,
          'from': isWalletSelected.value ? 'wallet' : 'bank',
          'bankId': isWalletSelected.value ? null : selectedBank?['id'],
          'recipientName': selectedProvider.value,
          'recipientInfo': selectedCategory.value,
          'status': 'success',
          'createdAt': Timestamp.now(),
        });
      });

      // Clear fields
      amount.value = 0.0;
      description.value = '';

      Get.snackbar(
        "Success",
        "Bill Payment Successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Success Navigation
      Get.offNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type:
              TransactionType.transfer, // Using transfer as generic for receipt
          amount: billAmount.toStringAsFixed(2),
          recipientName: selectedProvider.value,
          recipientInfo: selectedCategory.value,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to pay bill: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFallbackProviders(String category) {
    if (category == AppStrings.categoryElectricity ||
        category == AppStrings.electricBillTitle ||
        category == AppStrings.electricBill) {
      providers.assignAll([
        'Torrent Power',
        'Gujarat Vij Company',
        'Tata Power',
        'Adani Electricity',
      ]);
    } else if (category == AppStrings.categoryInternet) {
      providers.assignAll(['Jio Fiber', 'Airtel Xstream', 'GTPL', 'BSNL']);
    } else if (category == AppStrings.insurance) {
      providers.assignAll(['LIC', 'HDFC Ergo', 'ICICI Lombard', 'Star Health']);
    } else if (category == AppStrings.categoryMedical) {
      providers.assignAll([
        'Apollo Pharmacy',
        'Netmeds',
        'Pharmeasy',
        'Medplus',
      ]);
    } else if (category == AppStrings.categoryMarket) {
      providers.assignAll([
        'Reliance Fresh',
        'D-Mart',
        'Big Basket',
        'Amazon Fresh',
      ]);
    } else if (category == AppStrings.television ||
        category == AppStrings.televisionBillTitle) {
      providers.assignAll([
        'Tata Play',
        'Dish TV',
        'Airtel Digital TV',
        'Sun Direct',
      ]);
    } else if (category == AppStrings.waterBill) {
      providers.assignAll([
        'Municipal Corporation',
        'Water Board',
        'Housing Society',
      ]);
    } else {
      // Default fallback for any other category
      providers.assignAll(['Provider A', 'Provider B', 'Provider C']);
    }
  }

  void changeBank() {
    if (_walletController.savedBankAccounts.isEmpty) return;

    Get.bottomSheet(
      Container(
        color: Theme.of(Get.context!).cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppStrings.selectBank),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _walletController.savedBankAccounts.length,
                  itemBuilder: (context, index) {
                    final bank = _walletController.savedBankAccounts[index];
                    return ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: Text(
                        bank['bankName'] ?? 'Unknown Bank',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Text(
                        'Balance: \$${bank['balance']}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      onTap: () {
                        selectedBankIndex.value = index;
                        isWalletSelected.value = false; // Auto switch to bank
                        Get.back();
                      },
                      selected:
                          index == selectedBankIndex.value &&
                          !isWalletSelected.value,
                      trailing:
                          index == selectedBankIndex.value &&
                              !isWalletSelected.value
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
