import 'showtime.dart';

class Movie {
  final String id;
  final String title;
  final String posterPath;
  final String language;
  final String duration;
  final String description;
  final bool isComingSoon;
  final List<Showtime> showtimes;

  const Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.language,
    required this.duration,
    required this.description,
    required this.isComingSoon,
    required this.showtimes,
  });

  String? get imageUrl => null;
}
