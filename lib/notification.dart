import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _myToken = '';
  void initNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      _myToken = token;

      print("FCM Token: $_myToken");
    });
  }

  void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        showLocalNotification(notification);
      }
    });
  }

  void showLocalNotification(RemoteNotification notification) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

  Future<void> saveTokenToFirestore(String userId) async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> sendPushNotification(String receiverId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    if (!doc.exists || doc['fcmToken'] == null) {
      print("Receiver token not found");
      return;
    }

    final token = doc['fcmToken'];

    const String serverKey = 'YOUR_SERVER_KEY_HERE';

    final data = {
      "to": token,
      "notification": {
        "title": "New Order!",
        "body": "You received an order from userA",
      },
      "priority": "high",
    };

    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("✅ Notification sent");
    } else {
      print("❌ Failed to send: ${response.body}");
    }
  }
}
