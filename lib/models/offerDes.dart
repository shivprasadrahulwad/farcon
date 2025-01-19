import 'dart:convert';

class OfferDes {
  final String title;
  final String description;
  final String icon;

  OfferDes({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Convert `OfferDes` to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }

  /// Create an `OfferDes` object from a Map
  factory OfferDes.fromMap(Map<String, dynamic> map) {
    return OfferDes(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  /// Convert to JSON
  String toJson() => jsonEncode(toMap());

  /// Create an `OfferDes` object from JSON
  factory OfferDes.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return OfferDes.fromMap(map);
  }
}
