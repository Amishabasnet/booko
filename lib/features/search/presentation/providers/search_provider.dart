import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/search_movies.dart';

class SearchNotifier extends ChangeNotifier {
  SearchNotifier(this.searchMovies);

  final SearchMovies searchMovies;

  String query = '';
  bool loading = false;
  String? error;
  List<Movie> results = [];

  Future<void> search(String value) async {
    query = value;

    if (value.trim().isEmpty) {
      results = [];
      error = null;
      notifyListeners();
      return;
    }

    loading = true;
    error = null;
    notifyListeners();

    try {
      results = await searchMovies(value);
    } catch (e) {
      results = [];
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  void clear() {
    query = '';
    results = [];
    error = null;
    notifyListeners();
  }
}

/// ✅ Provide SearchMovies via Riverpod
final searchMoviesUsecaseProvider = Provider<SearchMovies>((ref) {
  throw UnimplementedError(
    'searchMoviesUsecaseProvider must be overridden in main.dart',
  );
});

/// ✅ This no longer throws directly; only the usecase provider must be overridden
final searchProvider = ChangeNotifierProvider<SearchNotifier>((ref) {
  final usecase = ref.watch(searchMoviesUsecaseProvider);
  return SearchNotifier(usecase);
});
