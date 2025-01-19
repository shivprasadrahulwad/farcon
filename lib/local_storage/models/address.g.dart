// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 3;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      addressType: fields[0] as String,
      flatNo: fields[1] as String,
      area: fields[3] as String,
      receiverName: fields[5] as String,
      receiverPhone: fields[6] as String,
      city: fields[7] as String,
      state: fields[8] as String,
      floor: fields[2] as String,
      landmark: fields[4] as String,
      isDefault: fields[9] as bool,
      isInUse: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.addressType)
      ..writeByte(1)
      ..write(obj.flatNo)
      ..writeByte(2)
      ..write(obj.floor)
      ..writeByte(3)
      ..write(obj.area)
      ..writeByte(4)
      ..write(obj.landmark)
      ..writeByte(5)
      ..write(obj.receiverName)
      ..writeByte(6)
      ..write(obj.receiverPhone)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.isDefault)
      ..writeByte(10)
      ..write(obj.isInUse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
