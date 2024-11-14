
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgorungMessage);
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device token: $token");
  }
  
}

Future<void> handleBackgorungMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}}');
  print('Body: ${message.notification?.body}}');
  print('Payload: ${message.data}}');
}