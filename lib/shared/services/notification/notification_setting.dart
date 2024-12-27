// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Setting notifikasi berdasarkan platform disini
class NotificationPlatformSetting {
  //Android Channel
  static const String _androidNotificationId = "";
  static const String _androidNotificationName = "";
  static AndroidNotificationChannel get androidNotificationChannel => const AndroidNotificationChannel(
    _androidNotificationId,
    _androidNotificationName,
    importance: Importance.max,
    playSound: true,
  );

  //Android Setting
  static const String _defaultIcon = "@mipmap/ic_launcher";
  // static const String _bigIcon = "@mipmap/notification";
  static const String _bigIcon = "@mipmap/ic_launcher";
  static AndroidInitializationSettings get androidInitializationSettings => const AndroidInitializationSettings(_defaultIcon);

  //Android Notification Details
  static AndroidNotificationDetails androidNotificationDetails(BigPictureStyleInformation? bigPictureStyleInformation) => AndroidNotificationDetails(
    androidNotificationChannel.id,
    androidNotificationChannel.name,
    icon: _defaultIcon,
    largeIcon: const DrawableResourceAndroidBitmap(_bigIcon),
    styleInformation: bigPictureStyleInformation ?? const BigTextStyleInformation(""),
    importance: Importance.max,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
    ticker: "ticker",
  );

  //iOS Setting
  static DarwinInitializationSettings get initializationSettingsIOS => DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
    onDidReceiveLocalNotification: (id, title, body, payload) {
      print("test notif on ios");
    },
  );

  static DarwinNotificationDetails darwinNotificationDetails(DarwinNotificationAttachment? darwinNotificationAttachment) => DarwinNotificationDetails(
    presentAlert: initializationSettingsIOS.defaultPresentAlert,
    presentBadge: initializationSettingsIOS.defaultPresentBadge,
    presentSound: initializationSettingsIOS.defaultPresentSound,
    attachments: darwinNotificationAttachment != null ? [darwinNotificationAttachment] : [],
  );

  //Initialization Setting
  static InitializationSettings get initializationSettings => InitializationSettings(
    android: androidInitializationSettings,
    iOS: initializationSettingsIOS,
  );
}