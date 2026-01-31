import '../repositories/profile_repository.dart';

class ClearProfileUseCase {
  final ProfileRepository repository;

  ClearProfileUseCase(this.repository);

  Future<void> call() {
    return repository.clearProfile();
  }
}
