import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/movie_local_datasource.dart';
import '../../data/models/movie_hive_model.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/search_movies.dart';

const String movieBoxName = 'movieBox';

final searchHiveInitProvider = FutureProvider<void>((ref) async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(MovieHiveModelAdapter());
  }

  if (!Hive.isBoxOpen(movieBoxName)) {
    await Hive.openBox<MovieHiveModel>(movieBoxName);
  }
});

final movieBoxProvider = Provider<Box<MovieHiveModel>>((ref) {
  ref.watch(searchHiveInitProvider); // ✅ forces init before Hive.box()
  return Hive.box<MovieHiveModel>(movieBoxName);
});

final localDataSourceProvider = Provider<MovieLocalDataSource>((ref) {
  final box = ref.watch(movieBoxProvider);
  return MovieLocalDataSource(box);
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(ref.watch(localDataSourceProvider));
});

final searchMoviesUsecaseProvider = Provider<SearchMovies>((ref) {
  return SearchMovies(ref.watch(movieRepositoryProvider));
});

class SearchState {
  final bool isLoading;
  final String query;
  final List<Movie> results;
  final String? error;

  const SearchState({
    required this.isLoading,
    required this.query,
    required this.results,
    this.error,
  });

  factory SearchState.initial() =>
      const SearchState(isLoading: true, query: '', results: [], error: null);

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<Movie>? results,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchMovies _usecase;
  Timer? _debounce;

  SearchNotifier(this._usecase) : super(SearchState.initial()) {
    init();
  }

  Future<void> init() async => _load('');

  Future<void> setQuery(String q) async {
    state = state.copyWith(query: q);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      await _load(q);
    });
  }

  Future<void> clear() async {
    state = state.copyWith(query: '');
    await _load('');
  }

  Future<void> _load(String q) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _usecase(q);
      state = state.copyWith(isLoading: false, results: list, error: null);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        results: const [],
        error: 'Failed to load movies',
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(ref.watch(searchMoviesUsecaseProvider));
});
