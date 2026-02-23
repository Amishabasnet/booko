import 'package:booko/features/movie/presentation/provider/movie_hive_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../search/data/models/movie_hive_model.dart';
import '../../data/models/showtime_hive_model.dart';
import 'seat_selection_screen.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final String movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required Map<String, String> movie,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() =>
      _MovieDetailRealtimeScreenState();
}

class _MovieDetailRealtimeScreenState extends ConsumerState<MovieDetailScreen> {
  int selectedDayIndex = 0; // 0 = today, 1 = tomorrow
  String selectedCinema = 'ALL';
  String selectedLanguage = 'ALL';

  DateTime _dayDate(int index) {
    final now = DateTime.now();
    final d = DateTime(now.year, now.month, now.day).add(Duration(days: index));
    return d;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure Hive initialized (no main.dart changes)
    final init = ref.watch(movieHiveInitProvider);

    return init.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Hive init failed: $e'))),
      data: (_) {
        final movieBox = ref.watch(movieBoxProvider);
        final showBox = ref.watch(showtimeBoxProvider);

        return ValueListenableBuilder(
          valueListenable: movieBox.listenable(),
          builder: (_, Box<MovieHiveModel> mBox, __) {
            final movie = mBox.values.firstWhere(
              (m) => m.id == widget.movieId,
              orElse: () => MovieHiveModel(
                id: widget.movieId,
                title: 'Movie',
                posterPath: '',
                language: '',
                duration: '',
                description: '',
                status: '',
              ),
            );

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff003366),
                  title: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  bottom: const TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: 'Time Slot'),
                      Tab(text: 'Movie Details'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    // TAB 1: time slots (real-time from showtimeBox)
                    ValueListenableBuilder(
                      valueListenable: showBox.listenable(),
                      builder: (_, Box<ShowtimeHiveModel> sBox, __) {
                        final day = _dayDate(selectedDayIndex);

                        // get showtimes of this movie for selected day
                        final showtimes = sBox.values.where((s) {
                          final sameMovie = s.movieId == widget.movieId;
                          final sameDay =
                              s.date.year == day.year &&
                              s.date.month == day.month &&
                              s.date.day == day.day;

                          final cinemaOk =
                              selectedCinema == 'ALL' ||
                              s.cinema == selectedCinema;
                          final langOk =
                              selectedLanguage == 'ALL' ||
                              s.language == selectedLanguage;

                          return sameMovie && sameDay && cinemaOk && langOk;
                        }).toList();

                        // Build filters from all showtimes of this movie/day
                        final allForDay = sBox.values.where((s) {
                          final sameMovie = s.movieId == widget.movieId;
                          final sameDay =
                              s.date.year == day.year &&
                              s.date.month == day.month &&
                              s.date.day == day.day;
                          return sameMovie && sameDay;
                        }).toList();

                        final cinemas = <String>{
                          'ALL',
                          ...allForDay.map((e) => e.cinema),
                        };
                        final languages = <String>{
                          'ALL',
                          ...allForDay.map((e) => e.language),
                        };

                        // group by cinema + language label similar to screenshot
                        final grouped = <String, List<ShowtimeHiveModel>>{};
                        for (final s in showtimes) {
                          final key = '${s.cinema} (${s.language})';
                          grouped.putIfAbsent(key, () => []).add(s);
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Poster header
                              AspectRatio(
                                aspectRatio: 16 / 8,
                                child: movie.posterPath.isEmpty
                                    ? Container(
                                        color: Colors.black12,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.broken_image_outlined,
                                        ),
                                      )
                                    : Image.asset(
                                        movie.posterPath,
                                        fit: BoxFit.cover,
                                      ),
                              ),

                              const SizedBox(height: 12),

                              // TODAY / TOMORROW
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    _DayCard(
                                      title: 'TODAY',
                                      dateLabel: _formatDay(_dayDate(0)),
                                      isSelected: selectedDayIndex == 0,
                                      onTap: () => setState(() {
                                        selectedDayIndex = 0;
                                        selectedCinema = 'ALL';
                                        selectedLanguage = 'ALL';
                                      }),
                                    ),
                                    const SizedBox(width: 10),
                                    _DayCard(
                                      title: 'TOMORROW',
                                      dateLabel: _formatDay(_dayDate(1)),
                                      isSelected: selectedDayIndex == 1,
                                      onTap: () => setState(() {
                                        selectedDayIndex = 1;
                                        selectedCinema = 'ALL';
                                        selectedLanguage = 'ALL';
                                      }),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Select Cinemas',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: cinemas.map((c) {
                                    return _ChipButton(
                                      text: c,
                                      selected: selectedCinema == c,
                                      onTap: () =>
                                          setState(() => selectedCinema = c),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Select Language',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: languages.map((l) {
                                    return _ChipButton(
                                      text: l,
                                      selected: selectedLanguage == l,
                                      onTap: () =>
                                          setState(() => selectedLanguage = l),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              if (grouped.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 20,
                                  ),
                                  child: Text('No showtimes found.'),
                                )
                              else
                                ...grouped.entries.map((entry) {
                                  final times = entry.value
                                    ..sort((a, b) => a.time.compareTo(b.time));
                                  return _ShowTimesSection(
                                    cinemaTitle: entry.key,
                                    times: times.map((e) => e.time).toList(),
                                    onTapTime: (t) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SeatSelectionScreen(
                                            movieTitle: movie.title,
                                            cinema: entry.key,
                                            time: t,
                                            dateLabel: selectedDayIndex == 0
                                                ? 'Today'
                                                : 'Tomorrow',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),

                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    ),

                    // TAB 2: Movie details (real-time movie data)
                    _MovieDetailsTab(
                      language: movie.language,
                      // You can add more fields into MovieHiveModel later (genre, director, etc.)
                      synopsis:
                          'Add more movie fields in Hive if you want this section fully dynamic.',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _formatDay(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm';
  }
}

class _DayCard extends StatelessWidget {
  final String title;
  final String dateLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCard({
    required this.title,
    required this.dateLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? const Color(0xff003366) : Colors.grey.shade300;
    final fg = isSelected ? Colors.white : Colors.black87;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ChipButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xff003366) : Colors.grey.shade300;
    final fg = selected ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ShowTimesSection extends StatelessWidget {
  final String cinemaTitle;
  final List<String> times;
  final void Function(String time) onTapTime;

  const _ShowTimesSection({
    required this.cinemaTitle,
    required this.times,
    required this.onTapTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cinemaTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: times.map((t) {
              return InkWell(
                onTap: () => onTapTime(t),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff003366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _MovieDetailsTab extends StatelessWidget {
  final String language;
  final String synopsis;

  const _MovieDetailsTab({required this.language, required this.synopsis});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Row(icon: Icons.language, label: 'LANGUAGE', value: language),
            _Row(
              icon: Icons.description_outlined,
              label: 'SYNOPSIS',
              value: synopsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
