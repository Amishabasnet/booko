import '../../domain/entities/movie.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_darasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.local, required this.remote});

  final SearchLocalDataSource local;
  final SearchRemoteDataSource remote;

  @override
  Future<List<Movie>> search(String query) async {
    // 1) Local (Hive) first
    final localResults = await local.searchLocal(query);
    if (localResults.isNotEmpty) return localResults;

    // 2) Remote fallback
    final remoteResults = await remote.searchRemote(query);

    // 3) Cache remote results into Hive (cache expects List<Movie>)
    await local.cacheMovies(remoteResults);

    return remoteResults;
  }
}
