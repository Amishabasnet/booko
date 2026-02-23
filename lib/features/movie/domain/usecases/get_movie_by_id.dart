import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieById {
  final MovieRepository repo;
  GetMovieById(this.repo);

  Future<Movie?> call(String id) => repo.getMovieById(id);
}
