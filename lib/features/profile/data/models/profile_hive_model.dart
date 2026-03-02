import 'package:hive/hive.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 21)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final DateTime dob;

  @HiveField(4)
  final String gender;

  ProfileHiveModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
  });
}
