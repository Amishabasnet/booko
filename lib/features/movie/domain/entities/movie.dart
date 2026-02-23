class Movie {
  final String id;
  final String title;
  final String posterAsset;

  final String genre;
  final int durationMin;
  final String language;

  final DateTime releaseDate;
  final String director;
  final List<String> cast;
  final String synopsis;

  const Movie({
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
}
