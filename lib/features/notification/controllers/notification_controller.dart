import 'package:expense/core/constants/app_images.dart';
import 'package:get/get.dart';

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

class NotificationController extends GetxController {
  final todayNotifications = <NotificationModel>[].obs;
  final yesterdayNotifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    todayNotifications.addAll([
      NotificationModel(
        icon: AppImages.electricBillBadge,
        title: 'Electric bill',
        status: 'Successful',
        amount: 420,
        date: '11:00 AM',
        isExpense: true,
      ),
      NotificationModel(
        icon: AppImages.waterbillBadge,
        title: 'Water bill',
        status: 'Successful',
        amount: 300,
        date: '1:00 PM',
        isExpense: true,
      ),
      NotificationModel(
        icon: '', // Fallback
        title: 'Johnsmith',
        status: 'Processing',
        amount: 1000,
        date: '2:25 PM',
        isExpense: true,
      ),
      NotificationModel(
        icon: '', // Fallback
        title: 'Loui',
        status: 'Successful',
        amount: 30,
        date: '3:00 PM',
        isExpense: false,
      ),
    ]);

    yesterdayNotifications.addAll([
      NotificationModel(
        icon: AppImages.marketBadge,
        title: 'Market',
        status: 'Successful',
        amount: 200,
        date: '4:20 AM',
        isExpense: true,
      ),
      NotificationModel(
        icon: AppImages.qrBadgeIcon,
        title: 'QR Payment',
        status: 'Successful',
        amount: 400,
        date: '5:00 PM',
        isExpense: true,
      ),
      NotificationModel(
        icon: AppImages.qrScannerBadgeIcon,
        title: 'QR Payment',
        status: 'Successful',
        amount: 200,
        date: '2:25 PM',
        isExpense: false,
      ),
      NotificationModel(
        icon: AppImages.televisionBadge,
        title: 'Television bill',
        status: 'Processing',
        amount: 350,
        date: '3:00 PM',
        isExpense: true,
      ),
    ]);
  }

  void deleteAllNotifications() {
    todayNotifications.clear();
    yesterdayNotifications.clear();
  }
}
