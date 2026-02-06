import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends GetView<AnalyticsController> {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.theme.iconTheme.color,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.tradingHistory,
          style: AppTextStyles.titleLarge.copyWith(
            color: context.theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final transactions = controller.transactions;
        if (transactions.isEmpty) {
          return Center(child: Text(AppStrings.noTransactions));
        }

        // Group transactions by date
        final groupedTransactions = _groupTransactionsByDate(transactions);

        return ListView.builder(
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final group = groupedTransactions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(context, group.date),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: group.items.map((item) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: TradingHistoryItemWidget(
                          icon: item.icon,
                          title: item.title,
                          status: item.status,
                          amount: item.amount,
                          date: item.date,
                          isExpense: item.isExpense,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: context.theme.scaffoldBackgroundColor,
      child: Text(
        date,
        style: AppTextStyles.titleSmall.copyWith(
          color: context.theme.textTheme.bodySmall?.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<_TransactionGroup> _groupTransactionsByDate(
    List<TransactionItem> items,
  ) {
    final Map<String, List<TransactionItem>> groups = {};
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    for (var item in items) {
      // items.date is formatted like "MMM dd - h:mm a"
      // We need to extract the date part for grouping
      String dateLabel;
      try {
        // Try to parse back the date or use a more robust grouping if date was stored as DateTime in controller
        // For now, let's use the date string prefix or logic based on current time
        // Actually, it's better to group by the actual DateTime if available.
        // But since TransactionItem already has a formatted date, let's try to group by the "MMM dd" part.
        final datePart = item.date.split(' - ')[0];

        // Check if it's today or yesterday
        final currentYear = now.year;
        final parsedDate = DateFormat(
          'MMM dd yyyy',
        ).parse('$datePart $currentYear');

        if (_isSameDay(parsedDate, now)) {
          dateLabel = AppStrings.today;
        } else if (_isSameDay(parsedDate, yesterday)) {
          dateLabel = AppStrings.yesterday;
        } else {
          dateLabel = datePart;
        }
      } catch (e) {
        dateLabel = item.date.split(' - ')[0];
      }

      if (!groups.containsKey(dateLabel)) {
        groups[dateLabel] = [];
      }
      groups[dateLabel]!.add(item);
    }

    return groups.entries
        .map((e) => _TransactionGroup(date: e.key, items: e.value))
        .toList();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

class _TransactionGroup {
  final String date;
  final List<TransactionItem> items;

  _TransactionGroup({required this.date, required this.items});
}
