// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutfitAdapter extends TypeAdapter<Outfit> {
  @override
  final int typeId = 1;

  @override
  Outfit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Outfit(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String?,
      itemIds: (fields[3] as List).cast<String>(),
      occasion: fields[4] as String,
      style: fields[5] as String?,
      season: fields[6] as String?,
      weatherCondition: fields[7] as String?,
      weatherTempMin: fields[8] as int?,
      weatherTempMax: fields[9] as int?,
      note: fields[10] as String?,
      isFavorite: fields[11] as bool? ?? false,
      aiGenerated: fields[12] as bool? ?? false,
      aiReasoning: fields[13] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Outfit obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.itemIds)
      ..writeByte(4)
      ..write(obj.occasion)
      ..writeByte(5)
      ..write(obj.style)
      ..writeByte(6)
      ..write(obj.season)
      ..writeByte(7)
      ..write(obj.weatherCondition)
      ..writeByte(8)
      ..write(obj.weatherTempMin)
      ..writeByte(9)
      ..write(obj.weatherTempMax)
      ..writeByte(10)
      ..write(obj.note)
      ..writeByte(11)
      ..write(obj.isFavorite)
      ..writeByte(12)
      ..write(obj.aiGenerated)
      ..writeByte(13)
      ..write(obj.aiReasoning)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
