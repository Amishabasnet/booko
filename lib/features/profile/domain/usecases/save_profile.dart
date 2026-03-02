import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SaveProfile {
  final ProfileRepository repo;
  SaveProfile(this.repo);

  Future<void> call(ProfileEntity profile) => repo.saveProfile(profile);
}
