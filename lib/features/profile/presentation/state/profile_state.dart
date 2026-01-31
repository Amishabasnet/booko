import '../../domain/entities/profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final ProfileEntity? profile; // nullable

  const ProfileState({required this.isLoading, required this.profile});

  factory ProfileState.initial() =>
      const ProfileState(isLoading: true, profile: null);

  ProfileState copyWith({bool? isLoading, ProfileEntity? profile}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile,
    );
  }
}
