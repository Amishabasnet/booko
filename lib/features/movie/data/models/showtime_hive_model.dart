import 'package:hive/hive.dart';

part 'showtime_hive_model.g.dart';

@HiveType(typeId: 21)
class ShowtimeHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String movieId;

  @HiveField(2)
  final String cinema; // e.g. "Civil Mall"

  @HiveField(3)
  final String language; // e.g. "Nepali"

  @HiveField(4)
  final DateTime date; // date only

  @HiveField(5)
  final String time; // e.g. "12:00 PM"

  ShowtimeHiveModel({
    required this.id,
    required this.movieId,
    required this.cinema,
    required this.language,
    required this.date,
    required this.time,
  });
}
