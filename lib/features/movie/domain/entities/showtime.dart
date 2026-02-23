class Showtime {
  final String id;
  final String movieId;
  final DateTime date; // day only
  final String cinema;
  final String language;
  final String timeLabel;

  const Showtime({
    required this.id,
    required this.movieId,
    required this.date,
    required this.cinema,
    required this.language,
    required this.timeLabel,
  });
}
