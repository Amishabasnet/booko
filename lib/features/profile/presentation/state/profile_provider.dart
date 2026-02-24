import 'package:booko/features/profile/presentation/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:booko/features/profile/data/models/profile_hive_model.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier()..loadProfile();
});

class ProfileState {
  final bool isLoading;
  final ProfileData? profile;

  ProfileState({required this.isLoading, required this.profile});

  factory ProfileState.initial() =>
      ProfileState(isLoading: true, profile: null);

  ProfileState copyWith({bool? isLoading, ProfileData? profile}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState.initial());

  Box<ProfileHiveModel> get _box => Hive.box<ProfileHiveModel>('profileBox');

  ProfileData _toData(ProfileHiveModel m) {
    return ProfileData(
      name: m.name,
      email: m.email,
      phoneNumber: m.phoneNumber,
      dob: m.dob,
      gender: m.gender,
      imagePath: m.imagePath,
    );
  }

  ProfileHiveModel _toModel(ProfileData d) {
    return ProfileHiveModel(
      name: d.name,
      email: d.email,
      phoneNumber: d.phoneNumber,
      dob: d.dob,
      gender: d.gender,
      imagePath: d.imagePath,
    );
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final model = _box.get('profile');
      state = ProfileState(
        isLoading: false,
        profile: model == null ? null : _toData(model),
      );
    } catch (_) {
      state = ProfileState(isLoading: false, profile: null);
    }
  }

  Future<void> saveProfile(ProfileData data) async {
    state = state.copyWith(profile: data);
    try {
      await _box.put('profile', _toModel(data));
    } catch (_) {}
  }
}
