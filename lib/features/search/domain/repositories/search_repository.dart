import '../entities/movie.dart';

abstract class SearchRepository {
  Future<List<Movie>> search(String query);
}
