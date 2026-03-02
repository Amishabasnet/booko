class Movie {
  final String id;
  final String title;
  final String language;
  final List<String> genres;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.language,
    required this.genres,
    required this.posterUrl,
  });
}
