import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String username;
  final String? password;

  const AuthEntity({
    required this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.dob,
    required this.gender,
    required this.username,
    this.password,
  });
  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    phoneNumber,
    dob,
    gender,
    username,
    password,
  ];
}
