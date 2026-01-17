import 'package:booko/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullname;
  final String email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String? password;

  AuthApiModel({
    this.id,
    required this.fullname,
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
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'gender': gender,
      'password': password,
    };
  }

  // from Json
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['id'] as String?,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      password: json['password'] as String?,
    );
  }

  // TO Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullname,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      password: password,
    );
  }

  // FROM Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullname: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      dob: entity.dob,
      gender: entity.gender,
      password: entity.password,
    );
  }

  // to entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
