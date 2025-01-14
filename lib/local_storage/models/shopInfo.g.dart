// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopInfoAdapter extends TypeAdapter<ShopInfo> {
  @override
  final int typeId = 4;

  @override
  ShopInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopInfo(
      number: fields[0] as int?,
      address: fields[1] as String?,
      shopName: fields[2] as String?,
      shopCode: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.shopName)
      ..writeByte(3)
      ..write(obj.shopCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
