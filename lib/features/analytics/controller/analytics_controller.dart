import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/core/utils/app_logger.dart';
import 'package:expense/features/wallet/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TimeFilter { last7Days, thirtyDays, custom }

class ChartData {
  final String date;
  final double income;
  final double expense;

  ChartData({required this.date, required this.income, required this.expense});
}

class TransactionItem {
  final String icon;
  final String title;
  final String status;
  final double amount;
  final String date;
  final bool isExpense;

  TransactionItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.amount,
    required this.date,
    required this.isExpense,
  });
}

class AnalyticsController extends GetxController {
  // Selected time filter
  final Rx<TimeFilter> selectedFilter = TimeFilter.last7Days.obs;

  // Custom date range
  final Rx<DateTime?> customStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> customEndDate = Rx<DateTime?>(null);

  // Chart data
  final RxList<ChartData> chartData = <ChartData>[].obs;

  // Transaction history from Firestore
  final RxList<TransactionModel> _allTransactions = <TransactionModel>[].obs;

  // Transaction history for UI
  final RxList<TransactionItem> transactions = <TransactionItem>[].obs;

  // Calculated totals
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalOutcome = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToTransactions();
  }

  void _listenToTransactions() {
    try {
      FirestoreService.userDoc()
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              _allTransactions.value = snapshot.docs
                  .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
                  .toList();
              _processData();
            },
            onError: (e) {
              AppLogger.error("Error listening to transactions: $e");
            },
          );
    } catch (e) {
      AppLogger.error("Error setting up transaction listener: $e");
    }
  }

  void setTimeFilter(TimeFilter filter) {
    selectedFilter.value = filter;
    _processData();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    selectedFilter.value = TimeFilter.custom;
    _processData();
  }

  void _processData() {
    final now = DateTime.now();
    DateTime rangeStart;

    switch (selectedFilter.value) {
      case TimeFilter.last7Days:
        rangeStart = now.subtract(const Duration(days: 7));
        break;
      case TimeFilter.thirtyDays:
        rangeStart = now.subtract(const Duration(days: 30));
        break;
      case TimeFilter.custom:
        rangeStart =
            customStartDate.value ?? now.subtract(const Duration(days: 7));
        break;
    }

    final rangeEnd = selectedFilter.value == TimeFilter.custom
        ? (customEndDate.value ?? now)
        : now;

    // Filter transactions by range
    final filteredTxns = _allTransactions.where((txn) {
      return txn.createdAt.isAfter(rangeStart) &&
          txn.createdAt.isBefore(rangeEnd.add(const Duration(days: 1)));
    }).toList();

    // Map to TransactionItem for history list
    transactions.value = filteredTxns.map((txn) {
      String icon = _getTransactionIcon(txn);

      return TransactionItem(
        icon: icon,
        title: txn.title,
        status: txn.displayStatus,
        amount: txn.amount,
        date: DateFormat('MMM dd - h:mm a').format(txn.createdAt),
        isExpense: txn.isExpense,
      );
    }).toList();

    // Calculate totals
    totalIncome.value = filteredTxns
        .where((txn) => !txn.isExpense)
        .fold(0.0, (sum, txn) => sum + txn.amount);
    totalOutcome.value = filteredTxns
        .where((txn) => txn.isExpense)
        .fold(0.0, (sum, txn) => sum + txn.amount);

    // Group by date for chart
    _updateChartData(filteredTxns, rangeStart, rangeEnd);
  }

  void _updateChartData(
    List<TransactionModel> txns,
    DateTime start,
    DateTime end,
  ) {
    final Map<String, ChartData> groupedData = {};

    // Determine grouping format based on range
    final daysCount = end.difference(start).inDays;
    final DateFormat formatter = daysCount > 31
        ? DateFormat('MMM yy')
        : DateFormat('dd-MM');

    // Initialize all days/periods with zero
    for (int i = 0; i <= daysCount; i++) {
      final date = start.add(Duration(days: i));
      final label = formatter.format(date);
      groupedData[label] = ChartData(date: label, income: 0, expense: 0);
    }

    // Aggregate transactions
    for (var txn in txns) {
      final label = formatter.format(txn.createdAt);
      if (groupedData.containsKey(label)) {
        final current = groupedData[label]!;
        groupedData[label] = ChartData(
          date: label,
          income: current.income + (!txn.isExpense ? txn.amount : 0),
          expense: current.expense + (txn.isExpense ? txn.amount : 0),
        );
      }
    }

    // Sort by date (already sorted by order of insertion in initialization loop if map respects insertion order,
    // but better to be explicit if needed. Luckily LinkedHashMap preserves order)
    chartData.value = groupedData.values.toList();
  }

  String _getTransactionIcon(TransactionModel tx) {
    if (tx.type == 'bill') {
      final category = tx.recipientInfo;
      if (category == AppStrings.categoryElectricity) {
        return AppImages.electricityBadge;
      }
      if (category == AppStrings.categoryInternet) {
        return AppImages.internetBadge;
      }
      if (category == AppStrings.insurance) return AppImages.insuranceBadge;
      if (category == AppStrings.categoryMedical) return AppImages.medicalBadge;
      if (category == AppStrings.categoryMarket) return AppImages.marketBadge;
      if (category == AppStrings.electricBill) {
        return AppImages.electricBillBadge;
      }
      if (category == AppStrings.television) return AppImages.televisionBadge;
      if (category == AppStrings.waterBill) return AppImages.waterbillBadge;
      return AppImages.electricBillBadge;
    }
    if (tx.type == 'topup') return AppImages.topupIcon;
    if (tx.type == 'withdraw') return AppImages.withdrawIcon;
    if (tx.type == 'transfer') return '';

    return AppImages.appLogoSquare; // Fallback
  }

  String get formattedStartDate {
    if (customStartDate.value == null) return '07/07/2021';
    final d = customStartDate.value!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String get formattedEndDate {
    if (customEndDate.value == null) return '19/07/2021';
    final d = customEndDate.value!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
