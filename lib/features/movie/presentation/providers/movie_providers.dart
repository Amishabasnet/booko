import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/movie_local_datasource.dart';
import '../../data/models/movie_hive_model.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/entities/movie.dart';

final movieHiveInitProvider = FutureProvider<void>((ref) async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(MovieHiveModelAdapter());
  }

  if (!Hive.isBoxOpen('movies')) {
    await Hive.openBox<MovieHiveModel>('movies');
  }
});

final movieBoxProvider = Provider<Box<MovieHiveModel>>((ref) {
  return Hive.box<MovieHiveModel>('movies');
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final box = ref.watch(movieBoxProvider);
  final ds = MovieLocalDataSource(box);
  return MovieRepositoryImpl(ds);
});

final nowShowingStreamProvider = StreamProvider<List<Movie>>((ref) async* {
  final repo = ref.watch(movieRepositoryProvider);
  yield* repo.watchNowShowing();
});

final comingSoonStreamProvider = StreamProvider<List<Movie>>((ref) async* {
  final repo = ref.watch(movieRepositoryProvider);
  yield* repo.watchComingSoon();
});

final movieByIdFutureProvider = FutureProvider.family<Movie?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(movieRepositoryProvider);
  return await repo.getMovie(id);
});

final seedMoviesProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(movieRepositoryProvider);
  await repo.seedIfEmpty();
});
