// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LikedProduct.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikedProductAdapter extends TypeAdapter<LikedProduct> {
  @override
  final int typeId = 0;

  @override
  LikedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikedProduct(
      id: fields[0] as String,
      likedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LikedProduct obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.likedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
