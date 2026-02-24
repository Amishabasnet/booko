class Showtime {
  final String id;
  final String movieId;
  final String cinema;
  final String language;
  final DateTime startTime;
  final int dayIndex;

  const Showtime({
    required this.id,
    required this.movieId,
    required this.cinema,
    required this.language,
    required this.startTime,
    required this.dayIndex,
  });

  String get formattedTime {
    final h = startTime.hour;
    final m = startTime.minute.toString().padLeft(2, '0');
    final isPm = h >= 12;
    final hh = (h % 12 == 0) ? 12 : (h % 12);
    return '$hh:$m ${isPm ? "PM" : "AM"}';
  }
}
