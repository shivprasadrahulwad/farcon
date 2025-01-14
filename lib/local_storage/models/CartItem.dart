import 'package:hive/hive.dart';

part 'CartItem.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String shopCode; // Field for shop code

  @HiveField(2)
  late final int quantity;

  CartItem({
    required this.id,
    required this.shopCode, // Add shopCode to the constructor
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopCode': shopCode, // Include shopCode in the map
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '', // Provide a default value if id is null
      shopCode: map['shopCode'] ?? '', // Provide a default value if shopCode is null
      quantity: map['quantity'] ?? 0, // Default to 0 if quantity is null
    );
  }
}
