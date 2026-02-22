import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repo;
  const SearchMovies(this.repo);

  Future<List<Movie>> call(String query) async {
    final q = query.trim();
    if (q.isEmpty) return repo.getAllMovies();
    return repo.searchMovies(q);
  }
}
