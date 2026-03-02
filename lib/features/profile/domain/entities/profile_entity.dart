class ProfileEntity {
  final String fullName;
  final String email;
  final String phone;
  final DateTime dob;
  final String gender;

  ProfileEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
  });

  ProfileEntity copyWith({
    String? fullName,
    String? email,
    String? phone,
    DateTime? dob,
    String? gender,
  }) {
    return ProfileEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
