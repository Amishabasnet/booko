import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

import '../../data/models/profile_hive_model.dart';

import 'profile_state.dart';
export 'profile_state.dart';

const String profileBoxName = 'profileBox';
const String profileKey = 'profile';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier()..loadProfile();
});

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

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState.initial());

  Box<ProfileHiveModel> get _box => Hive.box<ProfileHiveModel>(profileBoxName);

  ProfileData _toData(ProfileHiveModel m) => ProfileData(
    name: m.name,
    email: m.email,
    phoneNumber: m.phoneNumber,
    dob: m.dob,
    gender: m.gender,
    imagePath: m.imagePath,
  );

  ProfileHiveModel _toModel(ProfileData d) => ProfileHiveModel(
    name: d.name,
    email: d.email,
    phoneNumber: d.phoneNumber,
    dob: d.dob,
    gender: d.gender,
    imagePath: d.imagePath,
  );

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final model = _box.get(profileKey);
      state = ProfileState(
        isLoading: false,
        profile: model == null ? null : _toData(model),
      );
    } catch (e) {
      state = ProfileState(isLoading: false, profile: null, error: '$e');
    }
  }

  Future<void> saveProfile(ProfileData data) async {
    state = state.copyWith(profile: data, error: null);
    try {
      await _box.put(profileKey, _toModel(data));
    } catch (e) {
      state = state.copyWith(error: '$e');
    }
  }

  Future<void> updateImage(String? path) async {
    final current = state.profile;
    if (current == null) return;

    final updated = current.copyWith(imagePath: path);
    state = state.copyWith(profile: updated, error: null);

    try {
      await _box.put(profileKey, _toModel(updated));
    } catch (e) {
      state = state.copyWith(error: '$e');
    }
  }

  Future<void> clearProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _box.delete(profileKey);
      state = const ProfileState(isLoading: false, profile: null);
    } catch (e) {
      state = ProfileState(isLoading: false, profile: null, error: '$e');
    }
  }
}
