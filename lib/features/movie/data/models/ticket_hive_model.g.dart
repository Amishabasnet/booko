// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketModelAdapter extends TypeAdapter<TicketModel> {
  @override
  final int typeId = 1;

  @override
  TicketModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketModel(
      movieTitle: fields[0] as String,
      movieId: fields[1] as String,
      cinema: fields[2] as String,
      time: fields[3] as String,
      dayText: fields[4] as String,
      seats: (fields[5] as List).cast<String>(),
      totalPrice: fields[6] as int,
      eventDate: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TicketModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.movieTitle)
      ..writeByte(1)
      ..write(obj.movieId)
      ..writeByte(2)
      ..write(obj.cinema)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.dayText)
      ..writeByte(5)
      ..write(obj.seats)
      ..writeByte(6)
      ..write(obj.totalPrice)
      ..writeByte(7)
      ..write(obj.eventDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
