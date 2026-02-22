import 'package:flutter/material.dart';

import 'package:booko/features/movie/presentation/pages/movie_detail_screen.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  static const List<Map<String, String>> nowShowing = [
    {
      'title': 'Predator: Badlands',
      'image': 'assets/images/predator-badlands.jpg',
      'language': 'English',
      'duration': '1h 45m',
      'description':
          'A new Predator story set in harsh Badlands. Action, survival, and intense hunting.',
    },
    {
      'title': 'Paran',
      'image': 'assets/images/paran.jpg',
      'language': 'Nepali',
      'duration': '1h 50m',
      'description':
          'A Nepali thriller-drama with suspense and mystery elements.',
    },
    {
      'title': 'Man Binako Dhan',
      'image': 'assets/images/manbinakodhan.jpg',
      'language': 'Nepali',
      'duration': '2h 5m',
      'description':
          'A heartfelt Nepali story about relationships, struggle and growth.',
    },
    {
      'title': 'The Running Man',
      'image': 'assets/images/runningman.jpg',
      'language': 'English',
      'duration': '2h 0m',
      'description':
          'A high-stakes action movie where survival becomes entertainment.',
    },
    {
      'title': 'Wicked: For Good',
      'image': 'assets/images/wicked.jpg',
      'language': 'English',
      'duration': '1h 55m',
      'description':
          'A musical fantasy journey exploring friendship, destiny and magic.',
    },
  ];

  static const List<Map<String, String>> comingSoon = [
    {
      'title': 'Avengers: Secret Wars',
      'image': 'assets/images/avengers.jpg',
      'language': 'English',
      'duration': '2h 30m',
      'description':
          'Marvel heroes unite in a multiverse-level war with massive consequences.',
    },
    {
      'title': 'Joker: Folie à Deux',
      'image': 'assets/images/joker.jpg',
      'language': 'English',
      'duration': '2h 5m',
      'description':
          'A dark psychological story continuing Joker’s chaotic path.',
    },
    {
      'title': 'Dune: Part Three',
      'image': 'assets/images/dune3.jpeg',
      'language': 'English',
      'duration': '2h 35m',
      'description':
          'Epic sci-fi saga continues with power, prophecy, and war on Arrakis.',
    },
  ];

  void _openMovieDetail(BuildContext context, Map<String, String> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailScreen(movie: movie, movieId: ''),
      ),
    );
  }

  void _showComingSoonSnack(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$title is coming soon! Stay tuned.'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
        body: TabBarView(
          children: [
            _buildMovieGrid(
              context,
              nowShowing,
              onTap: (movie) => _openMovieDetail(context, movie),
            ),
            _buildMovieGrid(
              context,
              comingSoon,
              onTap: (movie) =>
                  _showComingSoonSnack(context, movie['title'] ?? 'Movie'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieGrid(
    BuildContext context,
    List<Map<String, String>> movies, {
    required void Function(Map<String, String> movie) onTap,
  }) {
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
            onTap: () => onTap(movie),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      movie['image'] ?? '',
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
                  movie['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${movie['language'] ?? ''} | ${movie['duration'] ?? ''}',
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
