import 'package:hive/hive.dart';
import 'package:booko/features/movie/data/models/movie_hive_model.dart';

class MovieLocalDataSource {
  final Box<MovieHiveModel> box;

  MovieLocalDataSource(this.box);

  // Fetch all movies
  List<MovieHiveModel> getAllMovies() {
    return box.values.toList();
  }

  // Watch movies
  Stream<List<MovieHiveModel>> watchAll() {
    return box.watch().map((event) {
      return box.values.toList();
    });
  }

  // Search for movies
  List<MovieHiveModel> searchMovies(String query) {
    return box.values
        .where(
          (movie) => movie.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Insert or update movie
  Future<void> upsert(MovieHiveModel movie) async {
    await box.put(movie.id, movie);
  }

  // Get movie by id
  MovieHiveModel? getById(String id) {
    return box.get(id);
  }
}
