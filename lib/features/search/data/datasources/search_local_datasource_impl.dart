import 'package:hive/hive.dart';

import '../../domain/entities/movie.dart';
import '../models/search_hive_model.dart';
import 'search_local_datasource.dart';

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  SearchLocalDataSourceImpl(this.box);

  final Box<SearchHiveModel> box;

  // ================= SEED LOCAL DATA =================
  @override
  Future<void> seedIfEmpty() async {
    if (box.isNotEmpty) return;

    await box.putAll({
      '1': SearchHiveModel(
        id: '1',
        title: 'Avatar',
        language: 'English',
        genres: const ['Sci-Fi', 'Action'],
        posterUrl: 'assets/images/avatar.jpg',
      ),
      '2': SearchHiveModel(
        id: '2',
        title: 'KGF',
        language: 'Kannada',
        genres: const ['Action', 'Drama'],
        posterUrl: 'assets/images/kgf.jpg',
      ),
      '3': SearchHiveModel(
        id: '3',
        title: 'Interstellar',
        language: 'English',
        genres: const ['Sci-Fi'],
        posterUrl: 'assets/images/interstellar.jpg',
      ),
      '4': SearchHiveModel(
        id: '4',
        title: 'Avengers',
        language: 'English',
        genres: const ['Action', 'Superhero'],
        posterUrl: 'assets/images/avengers.jpg',
      ),
      '5': SearchHiveModel(
        id: '5',
        title: 'Dune 3',
        language: 'English',
        genres: const ['Sci-Fi'],
        posterUrl: 'assets/images/dune3.jpg',
      ),
      '6': SearchHiveModel(
        id: '6',
        title: 'Joker',
        language: 'English',
        genres: const ['Drama', 'Crime'],
        posterUrl: 'assets/images/joker.jpg',
      ),
      '7': SearchHiveModel(
        id: '7',
        title: 'Manbin Kodhan',
        language: 'Nepali',
        genres: const ['Drama'],
        posterUrl: 'assets/images/manbinkodhan.jpg',
      ),
      '8': SearchHiveModel(
        id: '8',
        title: 'Paran',
        language: 'Nepali',
        genres: const ['Horror'],
        posterUrl: 'assets/images/paran.jpg',
      ),
      '9': SearchHiveModel(
        id: '9',
        title: 'Predator Badlands',
        language: 'English',
        genres: const ['Action', 'Sci-Fi'],
        posterUrl: 'assets/images/predator-badlands.jpg',
      ),
      '10': SearchHiveModel(
        id: '10',
        title: 'Running Man',
        language: 'Korean',
        genres: const ['Action', 'Comedy'],
        posterUrl: 'assets/images/runningman.jpg',
      ),
      '11': SearchHiveModel(
        id: '11',
        title: 'Wicked',
        language: 'English',
        genres: const ['Fantasy', 'Musical'],
        posterUrl: 'assets/images/wicked.jpg',
      ),
    });
  }

  // ================= LOCAL SEARCH =================
  @override
  Future<List<Movie>> searchLocal(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    bool matches(SearchHiveModel m) {
      final title = m.title.toLowerCase();
      final lang = m.language.toLowerCase();
      final genres = m.genres.map((g) => g.toLowerCase()).toList();

      return title.contains(q) ||
          lang.contains(q) ||
          genres.any((g) => g.contains(q));
    }

    return box.values
        .where(matches)
        .map(
          (m) => Movie(
            id: m.id,
            title: m.title,
            language: m.language,
            genres: m.genres,
            posterUrl: m.posterUrl,
          ),
        )
        .toList();
  }

  // ================= CACHE REMOTE =================
  @override
  Future<void> cacheMovies(List<Movie> movies) async {
    if (movies.isEmpty) return;

    final map = <String, SearchHiveModel>{};

    for (final m in movies) {
      final key = (m.id.isNotEmpty)
          ? m.id
          : '${m.title}-${m.language}'.toLowerCase();

      map[key] = SearchHiveModel(
        id: m.id.isNotEmpty ? m.id : key,
        title: m.title,
        language: m.language,
        genres: m.genres,
        posterUrl: m.posterUrl,
      );
    }

    await box.putAll(map);
  }
}
