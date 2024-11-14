// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_entity_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbEntityRecordAdapter extends TypeAdapter<DbEntityRecord> {
  @override
  final int typeId = 0;

  @override
  DbEntityRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DbEntityRecord(
      id: fields[0] as String,
      data: fields[1] == null
          ? const {}
          : (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DbEntityRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbEntityRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
