import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 11)
class MovieModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String posterAsset;

  @HiveField(3)
  String genre;

  @HiveField(4)
  int durationMin;

  @HiveField(5)
  String language;

  @HiveField(6)
  DateTime releaseDate;

  @HiveField(7)
  String director;

  @HiveField(8)
  List<String> cast;

  @HiveField(9)
  String synopsis;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterAsset,
    required this.genre,
    required this.durationMin,
    required this.language,
    required this.releaseDate,
    required this.director,
    required this.cast,
    required this.synopsis,
  });

  Movie toEntity() => Movie(
    id: id,
    title: title,
    posterAsset: posterAsset,
    genre: genre,
    durationMin: durationMin,
    language: language,
    releaseDate: releaseDate,
    director: director,
    cast: cast,
    synopsis: synopsis,
  );
}
