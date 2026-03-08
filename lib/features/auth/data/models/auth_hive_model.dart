import 'package:booko/core/constants/hive_table_constants.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? dob;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final String? password;

  AuthHiveModel({
    String? authId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.password,
  }) : authId = authId ?? const Uuid().v4();

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      password: entity.password,
    );
  }

  // Convert Hive model → AuthEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      password: password,
      token: null,
    );
  }

  // Convert List<HiveModel> → List<Entity>
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // From API model
  static AuthHiveModel fromApiModel(AuthApiModel user) {
    return AuthHiveModel(
      authId: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      dob: user.dob?.toIso8601String(),
      gender: user.gender,
      password: user.password,
    );
  }
}
