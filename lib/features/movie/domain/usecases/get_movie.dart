import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovie {
  final MovieRepository repo;
  GetMovie(this.repo);

  Future<Movie?> call(String id) => repo.getMovie(id);
}
