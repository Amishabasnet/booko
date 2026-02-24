import '../repositories/movie_repository.dart';

class SeedMoviesIfEmpty {
  final MovieRepository repo;
  SeedMoviesIfEmpty(this.repo);

  Future<void> call() => repo.seedIfEmpty();
}
