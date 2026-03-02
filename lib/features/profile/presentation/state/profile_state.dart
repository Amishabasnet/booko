class ProfileState {
  final bool isLoading;
  final String? error;

  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final String gender;

  const ProfileState({
    required this.isLoading,
    required this.error,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
  });

  factory ProfileState.initial() => const ProfileState(
    isLoading: true,
    error: null,
    fullName: '',
    email: '',
    phone: '',
    dob: '',
    gender: '',
  );

  get profile => null;

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? fullName,
    String? email,
    String? phone,
    String? dob,
    String? gender,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
