import '../entities/movie.dart';

abstract class MovieRepository {
  Stream<List<Movie>> watchNowShowing();
  Stream<List<Movie>> watchComingSoon();
  Future<Movie?> getMovie(String id);

  Future<void> seedIfEmpty();

  searchMovies(String query) async {}
}
