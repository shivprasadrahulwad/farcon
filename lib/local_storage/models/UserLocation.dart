import 'package:hive/hive.dart';

part 'UserLocation.g.dart';

@HiveType(typeId: 2)
class UserLocation extends HiveObject {
  @HiveField(0)
  final String shopCode; // New field for shop code

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  UserLocation({
    required this.shopCode, // Add shopCode to the constructor
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopCode': shopCode, // Include shopCode in the map
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      shopCode: map['shopCode'], // Retrieve shopCode from the map
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
