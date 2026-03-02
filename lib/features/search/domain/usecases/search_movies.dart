import '../entities/movie.dart';
import '../repositories/search_repository.dart';

class SearchMovies {
  final SearchRepository repository;

  SearchMovies(this.repository);

  Future<List<Movie>> call(String query) => repository.search(query);
}
