// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardItemAdapter extends TypeAdapter<BoardItem> {
  @override
  final int typeId = 4;

  @override
  BoardItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardItem(
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String?,
      fields[5] as String,
      fields[6] as String,
      fields[9] as bool,
      fields[7] as int,
      fields[8] as int,
      fields[11] as bool,
      (fields[12] as List).cast<dynamic>(),
      (fields[13] as List).cast<dynamic>(),
      fields[10] as bool,
      (fields[14] as List).cast<dynamic>(),
      (fields[15] as List).cast<BoardItem>(),
      (fields[16] as List?)?.cast<dynamic>(),
      fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BoardItem obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.responseTo)
      ..writeByte(5)
      ..write(obj.sender)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.numOfInappropriateFlags)
      ..writeByte(8)
      ..write(obj.numOfUpvotes)
      ..writeByte(9)
      ..write(obj.commentsDisabled)
      ..writeByte(10)
      ..write(obj.removed)
      ..writeByte(11)
      ..write(obj.public)
      ..writeByte(12)
      ..write(obj.readBy)
      ..writeByte(13)
      ..write(obj.recipients)
      ..writeByte(14)
      ..write(obj.upvotedBy)
      ..writeByte(15)
      ..write(obj.children)
      ..writeByte(16)
      ..write(obj.votedInappropriateBy)
      ..writeByte(17)
      ..write(obj.senderRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
