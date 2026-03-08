import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';
import 'search_api_model.dart';

part 'search_hive_model.g.dart';

@HiveType(typeId: 2)
class SearchHiveModel extends HiveObject implements Movie {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final String language;

  @override
  @HiveField(3)
  final List<String> genres;

  @override
  @HiveField(4)
  final String posterUrl;

  SearchHiveModel({
    required this.id,
    required this.title,
    required this.language,
    required this.genres,
    required this.posterUrl,
  });

  /// API → Hive
  factory SearchHiveModel.fromApiModel(SearchApiModel api) {
    return SearchHiveModel(
      id: api.id,
      title: api.title,
      language: api.language,
      genres: api.genres,
      posterUrl: api.posterUrl,
    );
  }

  /// Hive → Entity
  Movie toEntity() {
    return SearchHiveModel(
      id: id,
      title: title,
      language: language,
      genres: genres,
      posterUrl: posterUrl,
    );
  }
}
