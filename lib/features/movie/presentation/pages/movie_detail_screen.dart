import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pick_seats_screen.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final String movieId;
  final Map<String, String> movie;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final int _dayIndex = 0; // 0 today, 1 tomorrow
  String _cinema = 'ALL';
  final String _language = 'ALL';

  // Showtimes data structure
  final Map<String, List<Map<String, String>>> _showtimes = {
    'Bhaktapur': [
      {'time': '12:00 PM', 'cinema': 'Bhaktapur', 'language': 'Nepali'},
      {'time': '6:30 PM', 'cinema': 'Bhaktapur', 'language': 'Nepali'},
    ],
    'Civil Mall': [
      {'time': '11:30 AM', 'cinema': 'Civil Mall', 'language': 'Nepali'},
      {'time': '5:45 PM', 'cinema': 'Civil Mall', 'language': 'Nepali'},
    ],
    'Rising Mall': [
      {'time': '2:30 PM', 'cinema': 'Rising Mall', 'language': 'Nepali'},
      {'time': '8:00 PM', 'cinema': 'Rising Mall', 'language': 'English'},
    ],
    'Chhaya Center': [
      {'time': '12:00 PM', 'cinema': 'Chhaya Center', 'language': 'English'},
      {'time': '6:30 PM', 'cinema': 'Chhaya Center', 'language': 'English'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie['title'] ?? 'Movie Details',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Showtimes'),
            Tab(text: 'Movie Details'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Showtimes Tab (Redesigned with cinema filter)
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              AspectRatio(
                aspectRatio: 16 / 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    movie['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                movie['title']!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(movie['description']!),
              const SizedBox(height: 10),
              Text('Duration: ${movie['duration']}'),
              Text('Language: ${movie['language']}'),

              const SizedBox(height: 14),
              // Cinema selection section
              const Text(
                'Select Cinemas',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                      'ALL',
                      'Bhaktapur',
                      'Civil Mall',
                      'Rising Mall',
                      'Chhaya Center',
                    ].map((cinema) {
                      return _ChipButton(
                        text: cinema,
                        isActive: _cinema == cinema,
                        onTap: () {
                          setState(() {
                            _cinema = cinema;
                          });
                        },
                      );
                    }).toList(),
              ),

              const SizedBox(height: 14),
              // Showtime section for filtered cinema
              const Text(
                'Showtimes',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 8),

              // Filtering showtimes based on selected cinema
              _buildShowtimesByCinema(),
            ],
          ),

          // Movie Details Tab
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.grid_view_rounded,
                      title: 'GENRE',
                      value: 'DRAMA',
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      title: 'DURATION',
                      value: '${movie['duration']} | ${movie['language']}',
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Icons.article_outlined,
                      title: 'SYNOPSIS',
                      value: movie['description']!,
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Icons.date_range_rounded,
                      title: 'RELEASE DATE',
                      value: '2023-11-15',
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Icons.person_rounded,
                      title: 'DIRECTOR',
                      value: 'Deepak Prasad Acharya',
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Icons.people_rounded,
                      title: 'LEAD CAST',
                      value: 'Krishna Shrestha, Puja Gurung, Laxmi Adhikari',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the showtimes based on selected cinema
  Widget _buildShowtimesByCinema() {
    // Fetch showtimes for the selected cinema
    final showtimes = _cinema == 'ALL'
        ? _getAllShowtimes()
        : _showtimes[_cinema] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: showtimes.isEmpty
          ? [const Text('No showtimes available for this cinema')]
          : [
              // Using Wrap widget to display showtimes in a row-like structure
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: showtimes.map((showtime) {
                  return _TimeSlotButton(
                    time: showtime['time']!,
                    onTap: () => _navigateToPickSeatsScreen(showtime),
                  );
                }).toList(),
              ),
            ],
    );
  }

  // Get all showtimes for all cinemas
  List<Map<String, String>> _getAllShowtimes() {
    List<Map<String, String>> allShowtimes = [];
    _showtimes.forEach((cinema, times) {
      allShowtimes.addAll(times);
    });
    return allShowtimes;
  }

  // Navigate to PickSeatsScreen with the selected showtime
  void _navigateToPickSeatsScreen(Map<String, String> showtime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickSeatsScreen(
          cinema: showtime['cinema']!,
          time: showtime['time']!,
          movieTitle: '',
          movieId: '',
          dayIndex: _dayIndex,
        ),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _ChipButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade800 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _TimeSlotButton extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimeSlotButton({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          time,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
