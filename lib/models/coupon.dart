import 'dart:convert';

class Coupon {
  final String couponCode;
  final double off;
  final double? price;
  final int? customLimit;
  final bool? limit;
  final String? startDate;
  final String? endDate;
  final int? startTimeMinutes;
  final int? endTimeMinutes;

  Coupon({
    required this.couponCode,
    required this.off,
    this.price,
    this.customLimit,
    this.limit,
    this.startDate,
    this.endDate,
    this.startTimeMinutes,
    this.endTimeMinutes,
  });

  /// Convert `Coupon` to a Map
  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'off': off,
      'price': price,
      'customLimit': customLimit,
      'limit': limit,
      'startDate': startDate,
      'endDate': endDate,
      'startTimeMinutes': startTimeMinutes,
      'endTimeMinutes': endTimeMinutes,
    };
  }

  /// Create a `Coupon` object from a Map
  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      couponCode: map['couponCode'] ?? '',
      off: map['off']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble(),
      customLimit: map['customLimit'] as int?,
      limit: map['limit'] as bool?,
      startDate: map['startDate'] as String?,
      endDate: map['endDate'] as String?,
      startTimeMinutes: map['startTimeMinutes'] as int?,
      endTimeMinutes: map['endTimeMinutes'] as int?,
    );
  }

  /// Convert to JSON
  String toJson() => json.encode(toMap());

  /// Create a `Coupon` object from JSON
  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));

  /// Create a copy of `Coupon` with new values
  Coupon copyWith({
    String? couponCode,
    double? off,
    double? price,
    int? customLimit,
    bool? limit,
    String? startDate,
    String? endDate,
    int? startTimeMinutes,
    int? endTimeMinutes,
  }) {
    return Coupon(
      couponCode: couponCode ?? this.couponCode,
      off: off ?? this.off,
      price: price ?? this.price,
      customLimit: customLimit ?? this.customLimit,
      limit: limit ?? this.limit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTimeMinutes: startTimeMinutes ?? this.startTimeMinutes,
      endTimeMinutes: endTimeMinutes ?? this.endTimeMinutes,
    );
  }
}
