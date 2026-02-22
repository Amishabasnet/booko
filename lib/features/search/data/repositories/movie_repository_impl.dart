import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_datasource.dart';
import '../models/movie_hive_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource local;
  MovieRepositoryImpl(this.local);

  Movie _toEntity(MovieHiveModel m) => Movie(
    id: m.id,
    title: m.title,
    posterPath: m.posterPath,
    language: m.language,
  );

  @override
  Future<List<Movie>> getAllMovies() async {
    final list = await local.getAllMovies();
    return list.map(_toEntity).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final list = await local.searchMovies(query);
    return list.map(_toEntity).toList();
  }
}
