import 'package:hive/hive.dart';

part 'ticket_hive_model.g.dart';

@HiveType(typeId: 4)
class TicketHiveModel extends HiveObject {
  @HiveField(0)
  String movieTitle;

  @HiveField(1)
  String movieId;

  @HiveField(2)
  String cinema;

  @HiveField(3)
  String time;

  @HiveField(4)
  String dayText; // Booking date

  @HiveField(5)
  List<String> seats;

  @HiveField(6)
  int totalPrice;

  TicketHiveModel({
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayText,
    required this.seats,
    required this.totalPrice,
  });

  factory TicketHiveModel.fromJson(Map<String, dynamic> json) {
    return TicketHiveModel(
      movieTitle: json['movieTitle'] ?? '',
      movieId: json['movieId'] ?? '',
      cinema: json['cinema'] ?? '',
      time: json['time'] ?? '',
      dayText: json['date'] ?? '', // map API field to dayText
      seats: List<String>.from(json['seats'] ?? []),
      totalPrice: json['totalPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'movieTitle': movieTitle,
    'movieId': movieId,
    'cinema': cinema,
    'time': time,
    'date': dayText,
    'seats': seats,
    'totalPrice': totalPrice,
  };
}
