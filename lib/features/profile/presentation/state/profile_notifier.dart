import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfile;
  final SaveProfileUseCase _saveProfile;

  ProfileNotifier({
    required GetProfileUseCase getProfile,
    required SaveProfileUseCase saveProfile,
  }) : _getProfile = getProfile,
       _saveProfile = saveProfile,
       super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    final ProfileEntity? profile = await _getProfile();
    state = ProfileState(isLoading: false, profile: profile);
  }

  Future<void> save(ProfileEntity profile) async {
    // Update UI first
    state = state.copyWith(profile: profile);

    // Persist to Hive
    await _saveProfile(profile);
  }

  Future<void> updateImage(String? imagePath) async {
    final current = state.profile;
    if (current == null) return;

    final updated = current.copyWith(imagePath: imagePath);
    await save(updated);
  }

  Future<void> clearLocalProfile() async {
    // Optional: If you later add ClearProfileUseCase, use it here.
    // For now, just clear state in UI.
    state = state.copyWith(profile: null);
  }
}
