import 'dart:convert';

class shopInfo {
  final int? number;
  final String? address;
  final String? shopName;
  final String? shopCode;
  

  shopInfo({
    required this.number, 
    required this.address,
    required this.shopName,
    required this.shopCode
  });

  shopInfo copyWith({
    int? number,
    String? address,
    String? shopName,
    String? shopCode,
  }) {
    return shopInfo(
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

  factory shopInfo.fromMap(Map<String, dynamic> map) {
    return shopInfo(
      number: map['number']?.toInt() ?? 0,
      address: map['address'] ?? '',
      shopName: map['shopName'] ?? '',
      shopCode: map['shopCode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory shopInfo.fromJson(String source) => shopInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'shopInfo(number: $number, address: $address)';
}
