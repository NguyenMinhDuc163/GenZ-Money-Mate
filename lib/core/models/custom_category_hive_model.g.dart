// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_category_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCategoryHiveAdapter extends TypeAdapter<CustomCategoryHive> {
  @override
  final int typeId = 3;

  @override
  CustomCategoryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomCategoryHive(
      uuid: fields[0] as String,
      userId: fields[1] as String?,
      name: fields[2] as String,
      iconName: fields[3] as String,
      colorValue: fields[4] as int,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      isDefault: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomCategoryHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.iconName)
      ..writeByte(4)
      ..write(obj.colorValue)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCategoryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
