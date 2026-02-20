import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification != null) {
    NotificationService.instance.showNotification(
      title: message.notification!.title ?? "",
      body: message.notification!.body ?? "",
      payload: message.data,
    );
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    await _createNotificationChannel();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? "",
          body: message.notification!.body ?? "",
          payload: message.data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(jsonEncode(message.data));
    });
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    getDeviceToken();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("⚠️ Provisional permission granted");
    } else {
      print("❌ User denied permission");
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'transactions_channel',
      'Transactions',
      description: 'Notification for wallet transactions',
      importance: Importance.high,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.createNotificationChannel(channel);
  }

  Future<void> getDeviceToken() async {
    deviceTokenRefresh();
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device Token: $token");

    if (token != null) {
      await _saveTokenToFirestore(token);
    }
  }

  void deviceTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      print("Device Token Refreshed: $token");
      await _saveTokenToFirestore(token);
    });
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("❌ Cannot save token: User not logged in");
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });

      print("✅ FCM Token saved to Firestore");
    } catch (e) {
      print("❌ Error saving token: $e");
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'transactions_channel',
          'Transactions',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    final Map<String, dynamic> data = jsonDecode(payload);

    if (data['type'] == 'TRANSFER_SUCCESS') {
      Get.toNamed('/transaction-success', arguments: data['transactionId']);
    }
  }
}
