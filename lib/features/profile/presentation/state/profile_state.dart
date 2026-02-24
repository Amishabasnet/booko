class ProfileData {
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dob;
  final String gender;
  final String? imagePath;

  const ProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.imagePath,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? dob,
    String? gender,
    String? imagePath,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileState {
  final bool isLoading;
  final ProfileData? profile;
  final String? error;

  const ProfileState({
    required this.isLoading,
    required this.profile,
    this.error,
  });

  factory ProfileState.initial() =>
      const ProfileState(isLoading: true, profile: null);

  ProfileState copyWith({
    bool? isLoading,
    ProfileData? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}
