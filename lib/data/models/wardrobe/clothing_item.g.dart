// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingItemAdapter extends TypeAdapter<ClothingItem> {
  @override
  final int typeId = 0;

  @override
  ClothingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClothingItem(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      category: fields[3] as String,
      subCategory: fields[4] as String?,
      color: fields[5] as String,
      colorHex: fields[6] as String?,
      brand: fields[7] as String?,
      material: fields[8] as String?,
      season: (fields[9] as List).cast<String>(),
      occasion: (fields[10] as List).cast<String>(),
      styleTags: (fields[11] as List).cast<String>(),
      imagePath: fields[12] as String,
      thumbnailPath: fields[13] as String?,
      isFavorite: fields[14] as bool? ?? false,
      purchasePrice: fields[15] as double?,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
      notes: fields[18] as String?,
      aiConfidence: fields[19] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ClothingItem obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.subCategory)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.colorHex)
      ..writeByte(7)
      ..write(obj.brand)
      ..writeByte(8)
      ..write(obj.material)
      ..writeByte(9)
      ..write(obj.season)
      ..writeByte(10)
      ..write(obj.occasion)
      ..writeByte(11)
      ..write(obj.styleTags)
      ..writeByte(12)
      ..write(obj.imagePath)
      ..writeByte(13)
      ..write(obj.thumbnailPath)
      ..writeByte(14)
      ..write(obj.isFavorite)
      ..writeByte(15)
      ..write(obj.purchasePrice)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.notes)
      ..writeByte(19)
      ..write(obj.aiConfidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
