import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupPushNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission granted');

      // For handling messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('onMessage: $message');
        // Handle the received message
      });

      // For handling messages when the app is in the background but opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('onMessageOpenedApp: $message');
        // Handle the received message when the app is opened from the background
      });

      // For handling messages when the app is closed
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      print('No permission');
    }
  }

  // Background message handling function
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Handle the received message when the app is in the background
  }
}
