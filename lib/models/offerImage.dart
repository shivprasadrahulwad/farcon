class OfferImage {
  final List<String> imageUrls;
  final DateTime lastUpdated;

  OfferImage({
    required this.imageUrls,
    required this.lastUpdated,
  });

  // Copy method
  OfferImage copyWith({
    List<String>? imageUrls,
    DateTime? lastUpdated,
  }) {
    return OfferImage(
      imageUrls: imageUrls ?? this.imageUrls,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Convert the object to a map (useful for storage or JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'imageUrls': imageUrls,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create an object from a map (useful for storage or JSON deserialization)
  factory OfferImage.fromMap(Map<String, dynamic> map) {
    return OfferImage(
      imageUrls: List<String>.from(map['imageUrls']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  // Convert the object to a JSON string
  String toJson() => toMap().toString();

  // Create an object from a JSON string
  factory OfferImage.fromJson(String source) {
    final map = Map<String, dynamic>.from(Uri.decodeComponent(source) as Map);
    return OfferImage.fromMap(map);
  }
}
