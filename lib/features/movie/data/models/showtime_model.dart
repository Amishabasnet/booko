import 'package:hive/hive.dart';
import '../../domain/entities/showtime.dart';

part 'showtime_model.g.dart';

@HiveType(typeId: 12)
class ShowtimeModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String movieId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String cinema;

  @HiveField(4)
  String language;

  @HiveField(5)
  String timeLabel;

  ShowtimeModel({
    required this.id,
    required this.movieId,
    required this.date,
    required this.cinema,
    required this.language,
    required this.timeLabel,
  });

  Showtime toEntity() => Showtime(
    id: id,
    movieId: movieId,
    date: date,
    cinema: cinema,
    language: language,
    timeLabel: timeLabel,
  );
}
