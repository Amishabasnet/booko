import 'package:hive/hive.dart';
import '../models/movie_hive_model.dart';

class MovieLocalDataSource {
  final Box<MovieHiveModel> box;
  MovieLocalDataSource(this.box);

  Future<List<MovieHiveModel>> getAllMovies() async {
    return box.values.toList();
  }

  Future<List<MovieHiveModel>> searchMovies(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return box.values.toList();

    return box.values.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.language.toLowerCase().contains(q);
    }).toList();
  }
}
