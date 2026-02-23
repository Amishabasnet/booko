// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowtimeModelAdapter extends TypeAdapter<ShowtimeModel> {
  @override
  final int typeId = 12;

  @override
  ShowtimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShowtimeModel(
      id: fields[0] as String,
      movieId: fields[1] as String,
      date: fields[2] as DateTime,
      cinema: fields[3] as String,
      language: fields[4] as String,
      timeLabel: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShowtimeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movieId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.cinema)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.timeLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowtimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
