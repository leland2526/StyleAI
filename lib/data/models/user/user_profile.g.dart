// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 2;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      nickname: fields[1] as String,
      avatarPath: fields[2] as String?,
      gender: fields[3] as String?,
      birthday: fields[4] as DateTime?,
      heightCm: fields[5] as int?,
      weightKg: fields[6] as int?,
      bodyShape: fields[7] as String?,
      stylePreferences: (fields[8] as List).cast<String>(),
      colorPreferences: (fields[9] as List).cast<String>(),
      avoidColors: (fields[10] as List).cast<String>(),
      styleTestResult: fields[11] as String?,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.avatarPath)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.heightCm)
      ..writeByte(6)
      ..write(obj.weightKg)
      ..writeByte(7)
      ..write(obj.bodyShape)
      ..writeByte(8)
      ..write(obj.stylePreferences)
      ..writeByte(9)
      ..write(obj.colorPreferences)
      ..writeByte(10)
      ..write(obj.avoidColors)
      ..writeByte(11)
      ..write(obj.styleTestResult)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
