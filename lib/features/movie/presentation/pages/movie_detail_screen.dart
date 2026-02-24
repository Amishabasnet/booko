import 'package:flutter/material.dart';
import 'pick_seats_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Map<String, String> movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required String movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int selectedDayIndex = 0; // 0 = today, 1 = tomorrow
  String selectedCinema = 'ALL';
  String selectedLanguage = 'ALL';

  // ✅ STATIC SHOWTIMES (COMMENT OUT LATER)
  // Later you will replace this with Hive/API showtimes.
  static const List<Map<String, String>> staticShowtimes = [
    // cinema, language, day(0/1), time
    {
      'cinema': 'Bhaktapur',
      'language': 'Nepali',
      'day': '0',
      'time': '12:00 PM',
    },
    {
      'cinema': 'Bhaktapur',
      'language': 'Nepali',
      'day': '0',
      'time': '6:30 PM',
    },
    {
      'cinema': 'Civil Mall',
      'language': 'Nepali',
      'day': '0',
      'time': '11:30 PM',
    },
    {
      'cinema': 'Civil Mall',
      'language': 'Nepali',
      'day': '0',
      'time': '5:45 PM',
    },
    {
      'cinema': 'Labim Mall',
      'language': 'Nepali',
      'day': '0',
      'time': '2:30 PM',
    },
    {
      'cinema': 'Labim Mall',
      'language': 'Nepali',
      'day': '0',
      'time': '8:00 PM',
    },

    {
      'cinema': 'Bhaktapur',
      'language': 'Nepali',
      'day': '1',
      'time': '1:15 PM',
    },
    {
      'cinema': 'Bhaktapur',
      'language': 'Nepali',
      'day': '1',
      'time': '7:10 PM',
    },
    {
      'cinema': 'Civil Mall',
      'language': 'Nepali',
      'day': '1',
      'time': '12:10 PM',
    },
    {
      'cinema': 'Civil Mall',
      'language': 'Nepali',
      'day': '1',
      'time': '6:05 PM',
    },
  ];

  List<Map<String, String>> _filteredShowtimes() {
    final day = selectedDayIndex.toString();

    return staticShowtimes.where((s) {
      final okDay = s['day'] == day;
      final okCinema = selectedCinema == 'ALL' || s['cinema'] == selectedCinema;
      final okLang =
          selectedLanguage == 'ALL' || s['language'] == selectedLanguage;
      return okDay && okCinema && okLang;
    }).toList();
  }

  Set<String> _cinemasForSelectedDay() {
    final day = selectedDayIndex.toString();
    final set = <String>{'ALL'};
    for (final s in staticShowtimes) {
      if (s['day'] == day) set.add(s['cinema'] ?? '');
    }
    set.removeWhere((e) => e.isEmpty);
    return set;
  }

  Set<String> _languagesForSelectedDay() {
    final day = selectedDayIndex.toString();
    final set = <String>{'ALL'};
    for (final s in staticShowtimes) {
      if (s['day'] == day) set.add(s['language'] ?? '');
    }
    set.removeWhere((e) => e.isEmpty);
    return set;
  }

  void _openSeats({
    required String cinema,
    required String language,
    required String time,
  }) {
    final title = widget.movie['title'] ?? 'Movie';
    final dateLabel = selectedDayIndex == 0 ? 'Today' : 'Tomorrow';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie.dart';
import '../providers/movie_providers.dart';
import 'pick_seats_screen.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId, required Map<dynamic, dynamic> movie});

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _dayIndex = 0; // 0 today, 1 tomorrow
  String _cinema = 'ALL';
  String _language = 'ALL';

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

  void _goPickSeats({
    required Movie movie,
    required String cinema,
    required String time,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickSeatsScreen(
          movieTitle: title,
          cinema: '$cinema ($language)',
          dateLabel: dateLabel,
          time: time,
          movieTitle: movie.title,
          movieId: movie.id,
          cinema: cinema,
          time: time,
          dayIndex: _dayIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.movie['title'] ?? 'Movie';
    final poster = widget.movie['image'] ?? '';
    final language = widget.movie['language'] ?? '';
    final duration = widget.movie['duration'] ?? '';
    final description = widget.movie['description'] ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff003366),
          title: Text(title, style: const TextStyle(color: Colors.white)),
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
            // TAB 1: Time Slot
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 8,
                    child: Image.asset(
                      poster,
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
                  const SizedBox(height: 12),

                  // Today / Tomorrow (simple)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _DayCard(
                          title: 'TODAY',
                          date: '23\nNOV\nSAT',
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
                          date: '24\nNOV\nMON',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _cinemasForSelectedDay().map((c) {
                        return _ChipButton(
                          text: c,
                          selected: selectedCinema == c,
                          onTap: () => setState(() => selectedCinema = c),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _languagesForSelectedDay().map((l) {
                        return _ChipButton(
                          text: l,
                          selected: selectedLanguage == l,
                          onTap: () => setState(() => selectedLanguage = l),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Showtimes
                  Builder(
                    builder: (context) {
                      final list = _filteredShowtimes();

                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          child: Text('No showtimes found.'),
                        );
                      }

                      // Group by cinema(language)
                      final Map<String, List<Map<String, String>>> grouped = {};
                      for (final s in list) {
                        final key = '${s['cinema']} (${s['language']})';
                        grouped.putIfAbsent(key, () => []).add(s);
                      }

                      return Column(
                        children: grouped.entries.map((e) {
                          final title = e.key;
                          final times = e.value
                              .map((x) => x['time'] ?? '')
                              .where((t) => t.isNotEmpty)
                              .toList();

                          return _ShowTimesSection(
                            cinemaTitle: title,
                            times: times,
                            onTapTime: (t) {
                              // parse cinema + language from title
                              final cinema = e.value.first['cinema'] ?? '';
                              final lang = e.value.first['language'] ?? '';
                              _openSeats(
                                cinema: cinema,
                                language: lang,
                                time: t,
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // TAB 2: Movie Details
            SingleChildScrollView(
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
                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: 'LANGUAGE',
                      value: language,
                    ),
                    _DetailRow(
                      icon: Icons.access_time,
                      label: 'DURATION',
                      value: duration,
                    ),
                    _DetailRow(
                      icon: Icons.description_outlined,
                      label: 'SYNOPSIS',
                      value: description,
                    ),
                  ],
                ),
    final hiveInit = ref.watch(movieHiveInitProvider);

    return hiveInit.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Hive init failed: $e'))),
      data: (_) {
        final asyncMovie = ref.watch(movieByIdFutureProvider(widget.movieId));

        return asyncMovie.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
          data: (movie) {
            if (movie == null) {
              return const Scaffold(
                body: Center(child: Text('Movie not found')),
              );
            }

            final poster = movie.posterPath;

            final filteredShowtimes = movie.showtimes.where((s) {
              final dayOk = s.dayIndex == _dayIndex;
              final cinemaOk = _cinema == 'ALL' ? true : s.cinema == _cinema;
              final langOk = _language == 'ALL'
                  ? true
                  : s.language == _language;
              return dayOk && cinemaOk && langOk;
            }).toList();

            final cinemaList = <String>{
              'ALL',
              ...movie.showtimes.map((e) => e.cinema),
            }.toList();
            final langList = <String>{
              'ALL',
              ...movie.showtimes.map((e) => e.language),
            }.toList();

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Time Slot'),
                    Tab(text: 'Movie Details'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            poster,
                            fit: BoxFit.cover,
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
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _DayCard(
                              title: 'TODAY',
                              date: 'Today',
                              isSelected: _dayIndex == 0,
                              onTap: () => setState(() => _dayIndex = 0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _DayCard(
                              title: 'TOMORROW',
                              date: 'Tomorrow',
                              isSelected: _dayIndex == 1,
                              onTap: () => setState(() => _dayIndex = 1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Text(
                        'Select Cinemas',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cinemaList.map((c) {
                          return _ChipButton(
                            text: c,
                            isActive: _cinema == c,
                            onTap: () => setState(() => _cinema = c),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),
                      const Text(
                        'Select Language',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: langList.map((l) {
                          return _ChipButton(
                            text: l,
                            isActive: _language == l,
                            onTap: () => setState(() => _language = l),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      if (filteredShowtimes.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 18),
                            child: Text('No showtimes found'),
                          ),
                        )
                      else
                        ..._groupByCinema(filteredShowtimes).entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${e.key} (${movie.language})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: e.value.map((s) {
                                    return _TimeButton(
                                      time: s.formattedTime,
                                      onTap: () => _goPickSeats(
                                        movie: movie,
                                        cinema: s.cinema,
                                        time: s.formattedTime,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),

                  // Movie Details tab
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
                              value: '${movie.duration} | ${movie.language}',
                            ),
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Icons.article_outlined,
                              title: 'SYNOPSIS',
                              value: movie.description,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<dynamic>> _groupByCinema(List<dynamic> showtimes) {
    final map = <String, List<dynamic>>{};
    for (final s in showtimes) {
      final cinema = (s.cinema as String);
      map.putIfAbsent(cinema, () => []);
      map[cinema]!.add(s);
    }
    return map;
  }
}

class _DayCard extends StatelessWidget {
  final String title;
  final String date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCard({
    required this.title,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? Colors.blue.shade700 : Colors.grey.shade300;
    final fg = isSelected ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 10),
              Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              child: Text(
                date,
                style: TextStyle(color: fg, fontWeight: FontWeight.w800),
              ),
            ),
          ],
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

class _TimeButton extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimeButton({required this.time, required this.onTap});

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
          const SizedBox(height: 12),
        ],
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
    required this.label,
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
