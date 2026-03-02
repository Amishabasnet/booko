import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

part 'search_hive_model.g.dart';

@HiveType(typeId: 1)
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

  factory SearchHiveModel.fromJson(Map<String, dynamic> json) {
    return SearchHiveModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      language: (json['language'] ?? 'Unknown').toString(),
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      // supports: poster or posterUrl from API
      posterUrl: (json['poster'] ?? json['posterUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'language': language,
    'genres': genres,
    'poster': posterUrl,
  };
}
