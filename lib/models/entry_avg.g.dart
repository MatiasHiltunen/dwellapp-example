// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_avg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvgAdapter extends TypeAdapter<Avg> {
  @override
  final int typeId = 3;

  @override
  Avg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Avg(
      ts: fields[0] as DateTime,
      change: fields[1] as double,
      timeFrame: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Avg obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.ts)
      ..writeByte(1)
      ..write(obj.change)
      ..writeByte(2)
      ..write(obj.timeFrame)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.hour)
      ..writeByte(6)
      ..write(obj.x);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
