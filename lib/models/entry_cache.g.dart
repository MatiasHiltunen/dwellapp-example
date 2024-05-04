// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryCacheAdapter extends TypeAdapter<EntryCache> {
  @override
  final int typeId = 2;

  @override
  EntryCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntryCache(
      hash: fields[0] as int,
      data: (fields[1] as List).cast<Avg>(),
      minX: fields[2] as int,
      maxX: fields[3] as int,
      maxY: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, EntryCache obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hash)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.minX)
      ..writeByte(3)
      ..write(obj.maxX)
      ..writeByte(4)
      ..write(obj.maxY);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
