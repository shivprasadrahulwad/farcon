import 'package:hive/hive.dart';

part 'LikedProduct.g.dart';

@HiveType(typeId: 0)
class LikedProduct extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime likedAt;

  LikedProduct({
    required this.id,
    required this.likedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'likedAt': likedAt.toIso8601String(),
    };
  }

  factory LikedProduct.fromMap(Map<String, dynamic> map) {
    return LikedProduct(
      id: map['id'],
      likedAt: DateTime.parse(map['likedAt']),
    );
  }
}