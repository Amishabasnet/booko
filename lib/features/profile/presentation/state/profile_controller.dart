import 'package:booko/features/profile/domain/entities/profile_entity.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'profile_state.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      final session = ref.watch(UserSessionServiceProvider);
      return ProfileController(session)..load();
    });

class ProfileController extends StateNotifier<ProfileState> {
  final UserSessionService _session;

  ProfileController(this._session) : super(ProfileState.initial());

  Future<void> load() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // ✅ Use your session data saved during login/register
      // Adjust these getters to match your UserSessionService methods.
      final name = await _session.getName();
      final email = await _session.getEmail();
      final phone = await _session.getPhoneNumber();
      final dob = await _session.getDob();
      final gender = await _session.getGender();

      state = state.copyWith(
        isLoading: false,
        fullName: name ?? '',
        email: email ?? '',
        phone: phone ?? '',
        dob: dob ?? '',
        gender: gender ?? '',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> save(ProfileEntity profile) async {}

  Future<void> delete() async {}
}
