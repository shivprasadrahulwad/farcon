import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String subCategory;
  final String? offer;
  final int price;
  final int? discountPrice;
  final List<String> images;
  late final int quantity;
  final List<String> colors;
  final List<String> size;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    this.offer,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.quantity,
    required this.colors,
    required this.size,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? subCategory,
    String? offer,
    int? price,
    int? discountPrice,
    List<String>? images,
    int? quantity,
    List<String>? colors,
    List<String>? size,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      offer: offer ?? this.offer,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      images: images ?? this.images,
      quantity: quantity ?? this.quantity,
      colors: colors ?? this.colors,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'offer': offer,
      'price': price,
      'discountPrice': discountPrice,
      'images': images,
      'quantity': quantity,
      'colors': colors,
      'size': size,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      offer: map['offer'],
      price: map['price']?.toInt() ?? 0,
      discountPrice: map['discountPrice']?.toInt(),
      images: List<String>.from(map['images'] ?? []),
      quantity: map['quantity']?.toInt() ?? 0,
      colors: List<String>.from(map['colors'] ?? []),
      size: List<String>.from(map['size'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, category: $category, subCategory: $subCategory, offer: $offer, price: $price, discountPrice: $discountPrice, images: $images, quantity: $quantity, colors: $colors, size: $size)';
  }
}