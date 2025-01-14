import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final GlobalKey<NavigatorState> navigatorKey;

//   NotificationService({required this.navigatorKey});

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('@drawable/flutter_logo');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {},
//     );

//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         final String? payload = notificationResponse.payload;
//         if (payload != null) {
//           print('Notification payload: $payload');
//           _handleNotificationTap(payload);
//         }
//       },
//     );

//     print('Notifications initialized');
//   }

//   void _handleNotificationTap(String payload) {
//     final context = navigatorKey.currentContext;
//     if (context != null) {
//       switch (payload) {
//         case 'order_tracking':
//           Navigator.pushNamed(context, '/order-tracking');
//           break;
//         case 'profile':
//           Navigator.pushNamed(context, '/profile');
//           break;
//       }
//     }
//   }

//   Future<String?> _getImagePath() async {
//     try {
//       final String fileName = 'background.jpg';
//       final ByteData data = await rootBundle.load('assets/images/$fileName');
//       final directory = await getApplicationDocumentsDirectory();
//       final String filePath = '${directory.path}/$fileName';
//       final file = File(filePath);
//       await file.writeAsBytes(data.buffer.asUint8List());
//       return filePath;
//     } catch (e) {
//       print('Error loading image: $e');
//       return null;
//     }
//   }

//   Future<NotificationDetails> notificationDetails() async {
//     final largeIconPath = await _getImagePath();

//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       channelDescription: 'channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: BigTextStyleInformation(
//         '<b>Order placed Successfully</b>',
//         htmlFormatBigText: true,
//         htmlFormatContent: true,
//         htmlFormatTitle: true,
//         htmlFormatSummaryText: true,
//         summaryText: 'Click to track order',
//       ),
//       showWhen: true,
//       largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
//     );

//     final DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails(
//       attachments: largeIconPath != null
//           ? [DarwinNotificationAttachment(largeIconPath)]
//           : null,
//       threadIdentifier: "thread_id",
//     );

//     return NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//   }

//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async {
//     print('Attempting to show notification: $title - $body');
//     final details = await notificationDetails();
//     await notificationsPlugin.show(id, title, body, details, payload: payload);
//     print('Notification sent');
//   }
// }


class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationService({required this.navigatorKey});

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/flutter_logo');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          print('Notification payload: $payload');
          _handleNotificationTap(payload);
        }
      },
    );

    print('Notifications initialized');
  }

  void _handleNotificationTap(String payload) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      switch (payload) {
        case 'order_tracking':
          Navigator.pushNamed(context, '/order-tracking');
          break;
        case 'profile':
          Navigator.pushNamed(context, '/profile');
          break;
      }
    }
  }

  Future<String?> _getImagePath() async {
    try {
      final String fileName = 'flutter_logo.png';
      final ByteData data = await rootBundle.load('assets/$fileName');
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(data.buffer.asUint8List());
      return filePath;
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  Future<NotificationDetails> notificationDetails() async {
    final largeIconPath = await _getImagePath();

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        '<b>Order placed Successfully</b>',
        htmlFormatBigText: true,
        htmlFormatContent: true,
        htmlFormatTitle: true,
        htmlFormatSummaryText: true,
        summaryText: 'Click to track order',
      ),
      showWhen: true,
      largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
    );

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      attachments: largeIconPath != null
          ? [DarwinNotificationAttachment(largeIconPath)]
          : null,
      threadIdentifier: "thread_id",
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    print('Attempting to show notification: $title - $body');
    final details = await notificationDetails();
    await notificationsPlugin.show(id, title, body, details, payload: payload);
    print('Notification sent');
  }
}