import 'package:booko/features/profile/data/models/ticket_hive_model.dart';
import 'package:hive/hive.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 3)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  String fullName;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  DateTime dob; // store DateTime directly

  @HiveField(4)
  String gender;

  @HiveField(5)
  List<TicketHiveModel> myTickets;

  ProfileHiveModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.myTickets,
  });
}
