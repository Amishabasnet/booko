import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String name;
  final String email;
  final String? phoneNumber;
  final DateTime? dob; // keep as DateTime
  final String? gender;
  final String? password;

  AuthApiModel({
    this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.password,
  });

  // to Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob?.toIso8601String(), // safe conversion to string
      'gender': gender,
      'password': password,
    };
  }

  // from Json
  factory AuthApiModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AuthApiModel(
        id: null,
        name: "",
        email: "",
        phoneNumber: null,
        dob: null,
        gender: "prefer_not_to_say",
        password: null,
      );
    }

    return AuthApiModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phoneNumber: json['phoneNumber'] as String?,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      gender: (json['gender'] as String?)?.toLowerCase() ?? "prefer_not_to_say",
      password: json['password'] as String?,
    );
  }

  // TO Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob?.toIso8601String(),
      gender: gender,
      password: password, token: null,
    );
  }

  // FROM Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob != null ? DateTime.tryParse(entity.dob!) : null,
      gender: entity.gender,
      password: entity.password,
    );
  }

  // from Hive Model
  static AuthApiModel fromHiveModel(AuthHiveModel model) {
    return AuthApiModel(
      id: model.authId,
      name: model.name,
      email: model.email,
      phoneNumber: model.phoneNumber,
      dob: model.dob != null ? DateTime.tryParse(model.dob!) : null,
      gender: model.gender,
      password: model.password,
    );
  }

  // to entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
