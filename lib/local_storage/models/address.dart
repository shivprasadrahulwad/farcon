import 'package:hive/hive.dart';
part 'address.g.dart';

@HiveType(typeId: 3)
class Address extends HiveObject {
  @HiveField(0)
  String addressType;

  @HiveField(1)
  String flatNo;

  @HiveField(2)
  String floor;

  @HiveField(3)
  String area;

  @HiveField(4)
  String landmark;

  @HiveField(5)
  String receiverName;

  @HiveField(6)
  String receiverPhone;

  @HiveField(7)
  String city;

  @HiveField(8)
  String state;

  @HiveField(9)
  bool isDefault;

  @HiveField(10)
  bool isInUse;

  Address({
    required this.addressType,
    required this.flatNo,
    required this.area,
    required this.receiverName,
    required this.receiverPhone,
    required this.city,
    required this.state,
    this.floor = '',
    this.landmark = '',
    this.isDefault = false,
    this.isInUse = false,
  }) {
    // Validate required fields
    assert(addressType.isNotEmpty, 'Address type cannot be empty');
    assert(flatNo.isNotEmpty, 'Flat number cannot be empty');
    assert(area.isNotEmpty, 'Area cannot be empty');
    assert(receiverName.isNotEmpty, 'Receiver name cannot be empty');
    assert(receiverPhone.isNotEmpty, 'Receiver phone cannot be empty');
    assert(city.isNotEmpty, 'City cannot be empty');
    assert(state.isNotEmpty, 'State cannot be empty');
  }

  // Factory constructor to handle potentially null values from Hive
  factory Address.fromHive({
    required String? addressType,
    required String? flatNo,
    required String? floor,
    required String? area,
    required String? landmark,
    required String? receiverName,
    required String? receiverPhone,
    required String? city,
    required String? state,
    required bool? isDefault,
    required bool? isInUse,
  }) {
    return Address(
      addressType: addressType ?? '',
      flatNo: flatNo ?? '',
      floor: floor ?? '',
      area: area ?? '',
      landmark: landmark ?? '',
      receiverName: receiverName ?? '',
      receiverPhone: receiverPhone ?? '',
      city: city ?? '',
      state: state ?? '',
      isDefault: isDefault ?? false,
      isInUse: isInUse ?? false,
    );
  }

  // Add copyWith method for updates
  // Add copyWith method for updates
Address copyWith({
  String? addressType,
  String? flatNo,
  String? floor,
  String? area,
  String? landmark,
  String? receiverName,
  String? receiverPhone,
  String? city,
  String? state,
  bool? isDefault,
  bool? isInUse,
}) {
  final newAddress = Address(
    addressType: addressType ?? this.addressType,
    flatNo: flatNo ?? this.flatNo,
    floor: floor ?? this.floor,
    area: area ?? this.area,
    landmark: landmark ?? this.landmark,
    receiverName: receiverName ?? this.receiverName,
    receiverPhone: receiverPhone ?? this.receiverPhone,
    city: city ?? this.city,
    state: state ?? this.state,
    isDefault: isDefault ?? this.isDefault,
    isInUse: isInUse ?? this.isInUse,
  );
  
  return newAddress;
}

  String get fullAddress {
    final List<String> parts = [
      flatNo,
      if (floor.isNotEmpty) 'Floor: $floor',
      area,
      if (landmark.isNotEmpty) 'Near: $landmark',
      city,
      state,
    ];
    return parts.where((part) => part.isNotEmpty).join(', ');
  }

  // Helper method to validate address
  bool isValid() {
    return addressType.isNotEmpty &&
        flatNo.isNotEmpty &&
        area.isNotEmpty &&
        receiverName.isNotEmpty &&
        receiverPhone.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty;
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'Address{key: $key, addressType: $addressType, flatNo: $flatNo, floor: $floor, '
        'area: $area, landmark: $landmark, receiverName: $receiverName, '
        'receiverPhone: $receiverPhone, city: $city, state: $state, '
        'isDefault: $isDefault, isInUse: $isInUse}';
  }
}