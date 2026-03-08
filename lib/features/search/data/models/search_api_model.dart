import '../../domain/entities/movie.dart';

class SearchApiModel implements Movie {
  @override
  final String id;

  @override
  final String title;

  @override
  final String language;

  @override
  final List<String> genres;

  @override
  final String posterUrl;

  SearchApiModel({
    required this.id,
    required this.title,
    required this.language,
    required this.genres,
    required this.posterUrl,
  });

  factory SearchApiModel.fromJson(Map<String, dynamic> json) {
    return SearchApiModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      posterUrl: json['poster']?.toString() ?? '',
    );
  }
}
