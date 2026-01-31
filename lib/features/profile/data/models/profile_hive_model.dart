import 'package:hive/hive.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 10)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final DateTime dob;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String? imagePath;

  ProfileHiveModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.imagePath,
  });
}
