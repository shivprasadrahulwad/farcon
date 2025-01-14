import 'dart:convert';

class Category {
  final String id;
  final String categoryName;
  final List<String> subcategories;
  final String? categoryImage;

  Category({
    required this.id,
    required this.categoryName,
    required this.subcategories,
    this.categoryImage,
  });

  /// Convert `Category` to a Map
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'subcategories': subcategories,
      'categoryImage': categoryImage,
    };
  }

  /// Create a `Category` object from a Map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] ?? '',
      categoryName: map['categoryName'] ?? '',
      subcategories: List<String>.from(map['subcategories'] ?? []),
      categoryImage: map['categoryImage'],
    );
  }

  /// Convert to JSON
  String toJson() => json.encode(toMap());

  /// Create a `Category` object from JSON
  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  /// Create a copy of `Category` with new values
  Category copyWith({
    String? id,
    String? categoryName,
    List<String>? subcategories,
    String? categoryImage,
  }) {
    return Category(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      subcategories: subcategories ?? this.subcategories,
      categoryImage: categoryImage ?? this.categoryImage,
    );
  }
}
