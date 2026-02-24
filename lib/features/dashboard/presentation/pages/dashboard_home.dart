import 'package:booko/features/movie/presentation/pages/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../search/data/models/movie_hive_model.dart';
import '../../../search/presentation/providers/search_providers.dart';

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key});

  void _openMovieDetail(BuildContext context, String movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailScreen(movieId: movieId, movie: {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Ensure Hive is initialized (same init provider you used in search)
    final hiveInit = ref.watch(searchHiveInitProvider);

    return hiveInit.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Hive init failed: $e'))),
      data: (_) {
        final box = ref.watch(movieBoxProvider);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Booko',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xff003366),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'NOW SHOWING'),
                  Tab(text: 'COMING SOON'),
                ],
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (_, Box<MovieHiveModel> b, __) {
                final all = b.values.toList();

                final nowShowing = all
                    .where((m) => m.status == 'now_showing')
                    .toList();

                final comingSoon = all
                    .where((m) => m.status == 'coming_soon')
                    .toList();

                return TabBarView(
                  children: [
                    _buildMovieGrid(
                      context,
                      nowShowing,
                      onTap: (id) {
                        _openMovieDetail(context, id);
                      },
                    ),
                    _buildMovieGrid(
                      context,
                      comingSoon,
                      onTap: (id) {
                        _openMovieDetail(context, id);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieGrid(
    BuildContext context,
    List<MovieHiveModel> movies, {
    required void Function(String movieId) onTap,
  }) {
    if (movies.isEmpty) {
      return const Center(child: Text('No movies available'));
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];

          return InkWell(
            onTap: () => onTap(movie.id),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      movie.posterPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${movie.language} | ${movie.duration}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
