// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userName: fields[0] as String,
      role: fields[1] as String,
      id: fields[2] as String,
      accessToken: fields[3] as String,
      refreshToken: fields[4] as String,
      apartment: fields[6] as String?,
      authTokenExpires: fields[5] as int?,
      pet: fields[7] as int?,
      petName: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.accessToken)
      ..writeByte(4)
      ..write(obj.refreshToken)
      ..writeByte(5)
      ..write(obj.authTokenExpires)
      ..writeByte(6)
      ..write(obj.apartment)
      ..writeByte(7)
      ..write(obj.pet)
      ..writeByte(8)
      ..write(obj.petName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
