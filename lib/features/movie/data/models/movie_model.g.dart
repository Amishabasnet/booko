// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 11;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      posterAsset: fields[2] as String,
      genre: fields[3] as String,
      durationMin: fields[4] as int,
      language: fields[5] as String,
      releaseDate: fields[6] as DateTime,
      director: fields[7] as String,
      cast: (fields[8] as List).cast<String>(),
      synopsis: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterAsset)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.durationMin)
      ..writeByte(5)
      ..write(obj.language)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.director)
      ..writeByte(8)
      ..write(obj.cast)
      ..writeByte(9)
      ..write(obj.synopsis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
