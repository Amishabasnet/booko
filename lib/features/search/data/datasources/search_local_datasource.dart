import '../../domain/entities/movie.dart';

abstract class SearchLocalDataSource {
  Future<void> seedIfEmpty();

  Future<List<Movie>> searchLocal(String query);

  Future<void> cacheMovies(List<Movie> movies);
}