import 'package:booko/core/constants/hive_table_constants.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String dob;
  @HiveField(5)
  final String gender;
  @HiveField(6)
  final String username;
  @HiveField(7)
  final String? password;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.username,
    this.password,
  }) : authId = authId ?? Uuid().v4();

  // From Entity
  factory AuthHiveModel.fromEntity(entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      username: entity.username,
      password: entity.password,
    );
  }
  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      username: username,
      password: password,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
