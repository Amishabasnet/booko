import 'package:hive/hive.dart';

part 'ticket_hive_model.g.dart';

@HiveType(typeId: 1)
class TicketModel extends HiveObject {
  @HiveField(0)
  final String movieTitle;

  @HiveField(1)
  final String movieId;

  @HiveField(2)
  final String cinema;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final String dayText;

  @HiveField(5)
  final List<String> seats;

  @HiveField(6)
  final int totalPrice;

  @HiveField(7)
  final String eventDate;

  TicketModel({
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayText,
    required this.seats,
    required this.totalPrice,
    required this.eventDate,
  });
}
