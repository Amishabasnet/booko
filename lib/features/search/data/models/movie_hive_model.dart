import 'package:hive/hive.dart';

part 'movie_hive_model.g.dart';

@HiveType(typeId: 20)
class MovieHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String language;

  MovieHiveModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.language,
  });

  get status => null;

  get duration => null;
}
