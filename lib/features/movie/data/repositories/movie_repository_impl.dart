import 'package:booko/features/movie/domain/repositories/movie_repository.dart';
import 'package:booko/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:booko/features/movie/domain/entities/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource ds;

  MovieRepositoryImpl(this.ds);

  @override
  Stream<List<Movie>> watchNowShowing() {
    return ds.watchAll().map((items) {
      return items
          .where((m) => !m.isComingSoon)
          .map(
            (movie) => Movie(
              id: movie.id,
              title: movie.title,
              posterPath: movie.posterPath,
              language: movie.language,
              duration: movie.duration,
              description: movie.description,
              isComingSoon: movie.isComingSoon,
              showtimes: [],
            ),
          )
          .toList();
    });
  }

  @override
  Stream<List<Movie>> watchComingSoon() {
    return ds.watchAll().map((items) {
      return items
          .where((m) => m.isComingSoon)
          .map(
            (movie) => Movie(
              id: movie.id,
              title: movie.title,
              posterPath: movie.posterPath,
              language: movie.language,
              duration: movie.duration,
              description: movie.description,
              isComingSoon: movie.isComingSoon,
              showtimes: [],
            ),
          )
          .toList();
    });
  }

  @override
  Future<Movie?> getMovie(String id) async {
    final movie = ds.getById(id);
    return movie != null
        ? Movie(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            language: movie.language,
            duration: movie.duration,
            description: movie.description,
            isComingSoon: movie.isComingSoon,
            showtimes: [],
          )
        : null;
  }

  @override
  Future<void> seedIfEmpty() async {
    if (ds.getAllMovies().isEmpty) {
      // Seed your data here
    }
  }

  @override
  searchMovies(String query) {
    // TODO: implement searchMovies
    throw UnimplementedError();
  }
}
