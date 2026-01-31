class ProfileEntity {
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dob;
  final String gender;
  final String? imagePath;

  const ProfileEntity({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.imagePath,
  });

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? dob,
    String? gender,
    String? imagePath,
  }) {
    return ProfileEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
