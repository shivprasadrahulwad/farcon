import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'shopInfo.g.dart';

@HiveType(typeId: 4)
class ShopInfo extends HiveObject {
  @HiveField(0)
  final int? number;
  
  @HiveField(1)
  final String? address;
  
  @HiveField(2)
  final String? shopName;
  
  @HiveField(3)
  final String? shopCode;

  ShopInfo({
    required this.number,
    required this.address,
    required this.shopName,
    required this.shopCode,
  });

  ShopInfo copyWith({
    int? number,
    String? address,
    String? shopName,
    String? shopCode,
  }) {
    return ShopInfo(
      number: number ?? this.number,
      address: address ?? this.address,
      shopName: shopName ?? this.shopName,
      shopCode: shopCode ?? this.shopCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'address': address,
      'shopName': shopName,
      'shopCode': shopCode,
    };
  }

  factory ShopInfo.fromMap(Map<String, dynamic> map) {
    return ShopInfo(
      number: map['number']?.toInt() ?? 0,
      address: map['address'] ?? '',
      shopName: map['shopName'] ?? '',
      shopCode: map['shopCode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopInfo.fromJson(String source) =>
      ShopInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ShopInfo(number: $number, address: $address)';
}
