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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickSeatsScreen(
          movieTitle: title,
          cinema: '$cinema ($language)',
          dateLabel: dateLabel,
          time: time,
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
              ),
            ),
          ],
        ),
      ),
    );
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
                date,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
