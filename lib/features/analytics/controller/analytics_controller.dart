import 'package:expense/core/constants/app_images.dart';
import 'package:get/get.dart';

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

  // Transaction history
  final RxList<TransactionItem> transactions = <TransactionItem>[].obs;

  // Calculated totals
  double get totalIncome => chartData.fold(0, (sum, item) => sum + item.income);
  double get totalOutcome =>
      chartData.fold(0, (sum, item) => sum + item.expense);

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void setTimeFilter(TimeFilter filter) {
    selectedFilter.value = filter;
    _loadData();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    selectedFilter.value = TimeFilter.custom;
    _loadData();
  }

  void _loadData() {
    // Mock data based on selected filter
    switch (selectedFilter.value) {
      case TimeFilter.last7Days:
        _loadLast7DaysData();
        break;
      case TimeFilter.thirtyDays:
        _load30DaysData();
        break;
      case TimeFilter.custom:
        _loadCustomRangeData();
        break;
    }
    _loadTransactions();
  }

  void _loadLast7DaysData() {
    chartData.value = [
      ChartData(date: '21-06', income: 150, expense: 280),
      ChartData(date: '22-06', income: 380, expense: 320),
      ChartData(date: '23-06', income: 120, expense: 450),
      ChartData(date: '24-06', income: 280, expense: 200),
      ChartData(date: '25-06', income: 420, expense: 180),
      ChartData(date: '26-06', income: 200, expense: 350),
      ChartData(date: '05-07', income: 300, expense: 420),
    ];
  }

  void _load30DaysData() {
    chartData.value = [
      ChartData(date: 'W1', income: 850, expense: 720),
      ChartData(date: 'W2', income: 1200, expense: 980),
      ChartData(date: 'W3', income: 650, expense: 1100),
      ChartData(date: 'W4', income: 1500, expense: 850),
    ];
  }

  void _loadCustomRangeData() {
    // Mock data for custom range
    chartData.value = [
      ChartData(date: '07/07/2021', income: 400, expense: 350),
      ChartData(date: '19/07/2021', income: 250, expense: 480),
    ];
  }

  void _loadTransactions() {
    transactions.value = [
      TransactionItem(
        icon: AppImages.electricityBadge,
        title: 'Electric bill',
        status: 'Sent',
        amount: 420,
        date: 'Today - 11:00 AM',
        isExpense: true,
      ),
      TransactionItem(
        icon: AppImages.waterbillBadge,
        title: 'Water bill',
        status: 'Sent',
        amount: 27,
        date: 'Today - 2:30 PM',
        isExpense: true,
      ),
      TransactionItem(
        icon: "j",
        title: 'Johnsmith',
        status: 'Sent',
        amount: 1600,
        date: 'July 13 - 2:25 PM',
        isExpense: true,
      ),
    ];
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
