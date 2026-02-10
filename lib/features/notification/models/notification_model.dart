class NotificationModel {
  final String icon;
  final String title;
  final String status;
  final double amount;
  final String date;
  final bool isExpense;

  NotificationModel({
    required this.icon,
    required this.title,
    required this.status,
    required this.amount,
    required this.date,
    required this.isExpense,
  });
}
