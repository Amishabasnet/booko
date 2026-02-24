import 'package:hive/hive.dart';

part 'showtime_hive_model.g.dart';

@HiveType(typeId: 21)
class ShowtimeHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String movieId;

  @HiveField(2)
  final String cinema;

  @HiveField(3)
  final String language;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final int dayIndex; // 0=today, 1=tomorrow

  const ShowtimeHiveModel({
    required this.id,
    required this.movieId,
    required this.cinema,
    required this.language,
    required this.startTime,
    required this.dayIndex,
  });
}
