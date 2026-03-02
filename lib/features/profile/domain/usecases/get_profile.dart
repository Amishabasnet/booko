import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repo;
  GetProfile(this.repo);

  Future<ProfileEntity?> call() => repo.getProfile();
}
