import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/local/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';
import 'profile_notifier.dart';
import 'profile_state.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSourceImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(local: ref.read(profileLocalDataSourceProvider));
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(profileRepositoryProvider));
});

final saveProfileUseCaseProvider = Provider<SaveProfileUseCase>((ref) {
  return SaveProfileUseCase(ref.read(profileRepositoryProvider));
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(
    getProfile: ref.read(getProfileUseCaseProvider),
    saveProfile: ref.read(saveProfileUseCaseProvider),
  );
});
