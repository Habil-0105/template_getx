import 'package:firebase_messaging/firebase_messaging.dart';

abstract class BaseNotification {
  ///Initialize the notification service
  Future<void> initializeNotification();

  ///Setup notification plugin
  Future<void> setupNotificationPlugin();

  ///Request Permission Notification
  ///Here you can request permission firebase_messaging
  ///and The notification plugin
  Future<void> requestPermission();

  ///Handle received message firebase
  ///
  ///Handle received payload notification plugin
  void onReceivedNotification(Map<String,dynamic> data);

  ///Handle firebase onMessageOpened & onMessage listener
  void setupFirebaseListener();

  ///Get initial Firebase Cloud Messaging
  ///
  ///If the application has been opened from a terminated state via a [RemoteMessage] (containing a [Notification]), it will be returned, otherwise it will be null
  ///
  ///This function should be called inside screen
  ///
  ///This should be used to determine whether specific notification interaction should open the app with a specific purpose (e.g. opening a chat message, specific screen etc)
  Future<void> getInitialFCMNotification();
}