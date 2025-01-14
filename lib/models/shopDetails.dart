import 'dart:convert';

import 'package:shopez/models/category.dart';
import 'package:shopez/models/charges.dart';
import 'package:shopez/models/coupon.dart';
import 'package:shopez/models/orderSettings.dart';
import 'package:shopez/models/ratings.dart';


class ShopDetails {
  final String shopName;
  final String number;
  final String address;
  final String shopCode;
  final List<Category> categories;
  final double? delPrice;
  final Map<String, dynamic>? coupon; // Changed to Map<String, dynamic>?
  final Map<String, dynamic>? offerImages;
  final Map<String, dynamic>? offerDes;
  final DateTime? offertime;
  final List<String>? socialLinks;
  final DateTime lastUpdated;
  final Charges? charges;
  final List<Rating>? rating;
  final OrderSettings? orderSettings;

  ShopDetails({
    required this.shopName,
    required this.number,
    required this.address,
    required this.shopCode,
    required this.categories,
    this.delPrice,
    this.coupon,
    this.offerImages,
    this.offerDes,
    this.offertime,
    this.socialLinks,
    required this.lastUpdated,
    this.charges,
    this.rating,
    this.orderSettings,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'number': number,
      'address': address,
      'shopCode': shopCode,
      'categories': categories.map((x) => x.toMap()).toList(),
      'delPrice': delPrice,
      'coupon': coupon, // Directly pass the Map
      'offerImages': offerImages,
      'offerDes': offerDes,
      'offertime': offertime?.toIso8601String(),
      'socialLinks': socialLinks,
      'lastUpdated': lastUpdated.toIso8601String(),
      'charges': charges?.toMap(),
      'rating': rating?.map((x) => x.toMap()).toList(),
      'orderSettings': orderSettings?.toMap(),
    };
  }

  factory ShopDetails.fromMap(Map<String, dynamic> map) {
  // Helper function to handle Map or List to Map conversion
  Map<String, dynamic>? processMapData(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return Map<String, dynamic>.from(data); // Return as a Map
    } else if (data is List && data.isNotEmpty && data.first is Map) {
      return Map<String, dynamic>.from(data.first); // If it's a List, get the first item and treat it as a Map
    }
    return null; // Return null if the data is neither a Map nor List of Maps
  }

  return ShopDetails(
    shopName: map['shopName'] ?? '',
    number: map['number']?.toString() ?? '',
    address: map['address'] ?? '',
    shopCode: map['shopCode'] ?? '',
    categories: map['categories'] != null
        ? List<Category>.from((map['categories'] as List).map((x) => Category.fromMap(x)))
        : [],
    delPrice: map['delPrice'] != null
        ? (map['delPrice'] is int ? (map['delPrice'] as int).toDouble() : map['delPrice'] as double)
        : 0.0,
    coupon: processMapData(map['coupon']),
    offerImages: processMapData(map['offerImages']),
    offerDes: processMapData(map['offerDes']), // Use the helper to process this field
    offertime: map['offertime'] != null
        ? DateTime.parse(map['offertime'])
        : null,
    socialLinks: map['socialLinks'] is List
        ? List<String>.from(map['socialLinks'])
        : null,
    lastUpdated: map['lastUpdated'] != null
        ? DateTime.parse(map['lastUpdated'])
        : DateTime.now(),
    charges: map['charges'] != null ? Charges.fromMap(map['charges']) : null,
    rating: map['rating'] is List
        ? List<Rating>.from((map['rating'] as List).map((x) => Rating.fromMap(x)))
        : null,
    orderSettings: map['orderSettings'] != null ? OrderSettings.fromMap(map['orderSettings']) : null,
  );
}




  String toJson() => json.encode(toMap());

  factory ShopDetails.fromJson(String source) =>
      ShopDetails.fromMap(json.decode(source));

  ShopDetails copyWith({
    String? shopName,
    String? number,
    String? address,
    String? shopCode,
    List<Category>? categories,
    double? delPrice,
    Map<String, dynamic>? coupon, // Updated type
    Map<String, dynamic>? offerImages,
    Map<String, dynamic>? offerDes,
    DateTime? offertime,
    List<String>? socialLinks,
    DateTime? lastUpdated,
    Charges? charges,
    List<Rating>? rating,
    OrderSettings? orderSettings,
  }) {
    return ShopDetails(
      shopName: shopName ?? this.shopName,
      number: number ?? this.number,
      address: address ?? this.address,
      shopCode: shopCode ?? this.shopCode,
      categories: categories ?? this.categories,
      delPrice: delPrice ?? this.delPrice,
      coupon: coupon ?? this.coupon,
      offerImages: offerImages ?? this.offerImages,
      offerDes: offerDes ?? this.offerDes,
      offertime: offertime ?? this.offertime,
      socialLinks: socialLinks ?? this.socialLinks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      charges: charges ?? this.charges,
      rating: rating ?? this.rating,
      orderSettings: orderSettings ?? this.orderSettings,
    );
  }
}
