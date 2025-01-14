// import 'package:shopez/models/sessions.dart';
// import 'package:uuid/uuid.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io';

// class UserSession {
//   final String userId;
//   final String sessionId;
//   final String shopId;
//   final DateTime sessionStart;
//   final List<ScreenVisit> screensVisited;
//   final List<Action> actions;
//   final DeviceInfo deviceInfo;
//   final NetworkInfo networkInfo;

//   UserSession({
//     required this.userId,
//     required this.sessionId,
//     required this.shopId,
//     required this.sessionStart,
//     required this.screensVisited,
//     required this.actions,
//     required this.deviceInfo,
//     required this.networkInfo,
//   });

//   // Convert to Map for storing in a database or sending to a server
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'sessionId': sessionId,
//       'shopId': shopId,
//       'sessionStart': sessionStart.toIso8601String(),
//       'screensVisited': screensVisited.map((x) => x.toMap()).toList(),
//       'actions': actions.map((x) => x.toMap()).toList(),
//       'deviceInfo': deviceInfo.toMap(),
//       'networkInfo': networkInfo.toMap(),
//     };
//   }

//   // Convert from Map (when receiving data)
//   factory UserSession.fromMap(Map<String, dynamic> map) {
//     return UserSession(
//       userId: map['userId'] ?? '',
//       sessionId: map['sessionId'] ?? '',
//       shopId: map['shopId'] ?? '',
//       sessionStart: DateTime.parse(map['sessionStart']),
//       screensVisited: List<ScreenVisit>.from(
//         map['screensVisited']?.map((x) => ScreenVisit.fromMap(x))),
//       actions: List<Action>.from(map['actions']?.map((x) => Action.fromMap(x))),
//       deviceInfo: DeviceInfo.fromMap(map['deviceInfo']),
//       networkInfo: NetworkInfo.fromMap(map['networkInfo']),
//     );
//   }
// }

// UserSession? currentSession;

// Future<void> startSession(String userId, String shopId) async {
//   currentSession = UserSession(
//     userId: userId,
//     sessionId: Uuid().v4(),
//     shopId: shopId,
//     sessionStart: DateTime.now(),
//     screensVisited: [],
//     actions: [],
//     deviceInfo: await getDeviceInfo(),
//     networkInfo: await getNetworkInfo(),  // Wait for network info
//   );
// }

// void logScreenVisit(String screenName) {
//   if (currentSession == null) {
//     print('No active session');
//     return;
//   }
//   currentSession!.screensVisited.add(ScreenVisit(
//     screen: screenName,
//     timestamp: DateTime.now(),
//     shopId: currentSession?.shopId,
//   ));
// }

// // void endSession() {
// //   final sessionEnd = DateTime.now();
// //   final activeTime = sessionEnd.difference(currentSession!.sessionStart).inSeconds;
// //   print("Session Ended. Total Active Time: $activeTime seconds");

// //   // Sync with server here
// //   syncSessionData(currentSession!);
// //   currentSession = null;
// // }

// Future<DeviceInfo> getDeviceInfo() async {
//   final deviceInfoPlugin = DeviceInfoPlugin();
//   if (Platform.isAndroid) {
//     final androidInfo = await deviceInfoPlugin.androidInfo;
//     return DeviceInfo(
//       deviceType: "Mobile",
//       os: "Android",
//       osVersion: androidInfo.version.release ?? "Unknown",
//     );
//   } else if (Platform.isIOS) {
//     final iosInfo = await deviceInfoPlugin.iosInfo;
//     return DeviceInfo(
//       deviceType: "Mobile",
//       os: "iOS",
//       osVersion: iosInfo.systemVersion ?? "Unknown",
//     );
//   }
//   return DeviceInfo(deviceType: "Unknown", os: "Unknown", osVersion: "Unknown");
// }

// Future<NetworkInfo> getNetworkInfo() async {
//   final connectivity = await Connectivity().checkConnectivity();
//   String networkType = 'None';
//   if (connectivity == ConnectivityResult.wifi) {
//     networkType = 'WiFi';
//   } else if (connectivity == ConnectivityResult.mobile) {
//     networkType = 'Mobile';
//   }
  
//   // Placeholder for location; implement actual location logic if needed
//   String location = 'location';  

//   return NetworkInfo(networkType: networkType, location: location);
// }


// // Sync session data with the server (stub for now)
// void syncSessionData(UserSession session) {
//   // Implement API call to your server to save session data
//   print("Syncing session data with server...");
// }

