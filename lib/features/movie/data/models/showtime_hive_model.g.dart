// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowtimeHiveModelAdapter extends TypeAdapter<ShowtimeHiveModel> {
  @override
  final int typeId = 21;

  @override
  ShowtimeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShowtimeHiveModel(
      id: fields[0] as String,
      movieId: fields[1] as String,
      cinema: fields[2] as String,
      language: fields[3] as String,
      date: fields[4] as DateTime,
      time: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShowtimeHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movieId)
      ..writeByte(2)
      ..write(obj.cinema)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowtimeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
