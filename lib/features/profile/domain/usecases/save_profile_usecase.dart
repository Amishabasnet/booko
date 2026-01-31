import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) {
    return repository.saveProfile(profile);
  }
}
