// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHiveModelAdapter extends TypeAdapter<SearchHiveModel> {
  @override
  final int typeId = 1;

  @override
  SearchHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      language: fields[2] as String,
      genres: (fields[3] as List).cast<String>(),
      posterUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.genres)
      ..writeByte(4)
      ..write(obj.posterUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
