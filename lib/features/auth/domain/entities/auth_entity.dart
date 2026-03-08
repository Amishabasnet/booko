import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String? password;
  final String? token;

  const AuthEntity({
    this.authId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.password,
    this.token,
  });

  @override
  List<Object?> get props => [
        authId,
        name,
        email,
        phoneNumber,
        dob,
        gender,
        password,
        token,
      ];
}
