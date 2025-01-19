// class ScreenVisit {
//   final String screen;
//   final DateTime timestamp;
//   final String? shopId;

//   ScreenVisit({
//     required this.screen,
//     required this.timestamp,
//     this.shopId,
//   });

//   // Convert to Map for storing in a database or sending to a server
//   Map<String, dynamic> toMap() {
//     return {
//       'screen': screen,
//       'timestamp': timestamp.toIso8601String(),
//       'shopId': shopId,
//     };
//   }

//   // Convert from Map (when receiving data)
//   factory ScreenVisit.fromMap(Map<String, dynamic> map) {
//     return ScreenVisit(
//       screen: map['screen'] ?? '',
//       timestamp: DateTime.parse(map['timestamp']),
//       shopId: map['shopId'],
//     );
//   }
// }

// class Action {
//   final String action;
//   final String? item;
//   final DateTime timestamp;
//   final String? shopId;

//   Action({
//     required this.action,
//     this.item,
//     required this.timestamp,
//     this.shopId,
//   });

//   // Convert to Map for storing in a database or sending to a server
//   Map<String, dynamic> toMap() {
//     return {
//       'action': action,
//       'item': item,
//       'timestamp': timestamp.toIso8601String(),
//       'shopId': shopId,
//     };
//   }

//   // Convert from Map (when receiving data)
//   factory Action.fromMap(Map<String, dynamic> map) {
//     return Action(
//       action: map['action'] ?? '',
//       item: map['item'],
//       timestamp: DateTime.parse(map['timestamp']),
//       shopId: map['shopId'],
//     );
//   }
// }

// class DeviceInfo {
//   final String deviceType;
//   final String os;
//   final String osVersion;

//   DeviceInfo({
//     required this.deviceType,
//     required this.os,
//     required this.osVersion,
//   });

//   // Convert to Map for storing in a database or sending to a server
//   Map<String, dynamic> toMap() {
//     return {
//       'deviceType': deviceType,
//       'os': os,
//       'osVersion': osVersion,
//     };
//   }

//   // Convert from Map (when receiving data)
//   factory DeviceInfo.fromMap(Map<String, dynamic> map) {
//     return DeviceInfo(
//       deviceType: map['deviceType'] ?? '',
//       os: map['os'] ?? '',
//       osVersion: map['osVersion'] ?? '',
//     );
//   }
// }

// class NetworkInfo {
//   final String networkType;
//   final String location;

//   NetworkInfo({
//     required this.networkType,
//     required this.location,
//   });

//   // Convert to Map for storing or sending to the server
//   Map<String, dynamic> toMap() {
//     return {
//       'networkType': networkType,
//       'location': location,
//     };
//   }

//   // Convert from Map (when receiving data)
//   factory NetworkInfo.fromMap(Map<String, dynamic> map) {
//     return NetworkInfo(
//       networkType: map['networkType'] ?? '',
//       location: map['location'] ?? '',
//     );
//   }
// }
