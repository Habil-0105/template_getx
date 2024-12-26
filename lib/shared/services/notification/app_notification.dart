// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:template_getx/shared/services/notification/base_notification.dart';
import 'package:template_getx/shared/services/notification/notification_setting.dart';

@pragma('vm:entry-point')
void receiveNotificationBackground(NotificationResponse payload) {
  print("In Background");
  Map<String, dynamic> data = jsonDecode(payload.payload.toString());
  //Handle data payload in background
  AppNotification.instance.onReceivedNotification(data);
}

Future<void> onBackgroundMessageFirebase(RemoteMessage message) async {
  print("In Background2");
  await AppNotification.instance.initializeNotification();
  await Firebase.initializeApp();
}

class AppNotification extends BaseNotification {
  static final AppNotification instance = AppNotification._();

  AppNotification._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initializeNotification() async {
    await setupNotificationPlugin();
    setupFirebaseListener();
  }

  @override
  Future<void> setupNotificationPlugin() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationPlatformSetting.androidNotificationChannel);

    await requestPermission();

    await flutterLocalNotificationsPlugin.initialize(
      NotificationPlatformSetting.initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        Map<String, dynamic> data = jsonDecode(details.payload.toString());
        print(details);
        onReceivedNotification(data);
      },
      onDidReceiveBackgroundNotificationResponse: receiveNotificationBackground,
    );
  }

  @override
  Future<void> requestPermission() async {
    FirebaseMessaging.instance.requestPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          sound: NotificationPlatformSetting
              .initializationSettingsIOS.requestSoundPermission,
          alert: NotificationPlatformSetting
              .initializationSettingsIOS.requestAlertPermission,
          badge: NotificationPlatformSetting
              .initializationSettingsIOS.requestBadgePermission,
        );
  }

  @override
  void setupFirebaseListener() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) => onReceivedNotification(message.data));

    FirebaseMessaging.onMessage.listen((message) async {
      log('>>>>A new onMessage event was published!<<<<');
      log("message : $message");
      log("data : ${message.data}");
      log("MESSAGE: ${message.toMap()}");
      Map<String, dynamic> data = message.data;
      log("data : $data");

      //Get image notification
      BigPictureStyleInformation? bigPictureStyleInformation;
      DarwinNotificationAttachment? darwinNotificationAttachment;

      //Show notification
      flutterLocalNotificationsPlugin.show(
        1,
        data["title"],
        data["body"],
        NotificationDetails(
          android: NotificationPlatformSetting.androidNotificationDetails(bigPictureStyleInformation),
          iOS: NotificationPlatformSetting.darwinNotificationDetails(
              darwinNotificationAttachment),
        ),
        payload: jsonEncode(data),
      );
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageFirebase);
  }

  @override
  Future<void> getInitialFCMNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Map<String, dynamic> data = message.data;
      onReceivedNotification(data);
    }
  }

  @override
  void onReceivedNotification(Map<String, dynamic> data) async {
    print("on select notification at foreground");
  }
}
