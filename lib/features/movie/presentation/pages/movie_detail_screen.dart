import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pick_seats_screen.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final Map<String, String> movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int selectedDayIndex = 0; // 0 = today, 1 = tomorrow
  String selectedCinema = 'ALL';
  String selectedLanguage = 'ALL';

  // Static showtimes for now
  static const List<Map<String, String>> staticShowtimes = [
    {'cinema': 'Bhaktapur', 'language': 'Nepali', 'day': '0', 'time': '12:00 PM'},
    {'cinema': 'Bhaktapur', 'language': 'Nepali', 'day': '0', 'time': '6:30 PM'},
    {'cinema': 'Civil Mall', 'language': 'Nepali', 'day': '0', 'time': '11:30 AM'},
    {'cinema': 'Civil Mall', 'language': 'Nepali', 'day': '0', 'time': '5:45 PM'},
    {'cinema': 'Labim Mall', 'language': 'Nepali', 'day': '0', 'time': '2:30 PM'},
    {'cinema': 'Labim Mall', 'language': 'Nepali', 'day': '0', 'time': '8:00 PM'},
    {'cinema': 'Bhaktapur', 'language': 'Nepali', 'day': '1', 'time': '1:15 PM'},
    {'cinema': 'Bhaktapur', 'language': 'Nepali', 'day': '1', 'time': '7:10 PM'},
    {'cinema': 'Civil Mall', 'language': 'Nepali', 'day': '1', 'time': '12:10 PM'},
    {'cinema': 'Civil Mall', 'language': 'Nepali', 'day': '1', 'time': '6:05 PM'},
    {'cinema': 'Rising Mall', 'language': 'Nepali', 'day': '0', 'time': '2:30 PM'},
    {'cinema': 'Rising Mall', 'language': 'English', 'day': '0', 'time': '8:00 PM'},
    {'cinema': 'Chhaya Center', 'language': 'English', 'day': '0', 'time': '12:00 PM'},
    {'cinema': 'Chhaya Center', 'language': 'English', 'day': '0', 'time': '6:30 PM'},
  ];

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

  List<Map<String, String>> _filteredShowtimes() {
    final day = selectedDayIndex.toString();
    return staticShowtimes.where((s) {
      final okDay = s['day'] == day;
      final okCinema = selectedCinema == 'ALL' || s['cinema'] == selectedCinema;
      final okLang = selectedLanguage == 'ALL' || s['language'] == selectedLanguage;
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
          movieId: widget.movie['title'] ?? '', // Using title as fallback ID
          cinema: cinema,
          dateLabel: dateLabel,
          time: time,
          dayIndex: selectedDayIndex,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff003366),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Time Slot'),
            Tab(text: 'Movie Details'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
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
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                        date: '24\nNOV\nSUN',
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
                  child: Text('Select Cinemas', style: TextStyle(fontWeight: FontWeight.w700)),
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
                        isActive: selectedCinema == c,
                        onTap: () => setState(() => selectedCinema = c),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Select Language', style: TextStyle(fontWeight: FontWeight.w700)),
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
                        isActive: selectedLanguage == l,
                        onTap: () => setState(() => selectedLanguage = l),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final list = _filteredShowtimes();
                    if (list.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        child: Text('No showtimes found.'),
                      );
                    }
                    final Map<String, List<Map<String, String>>> grouped = {};
                    for (final s in list) {
                      final key = '${s['cinema']} (${s['language']})';
                      grouped.putIfAbsent(key, () => []).add(s);
                    }
                    return Column(
                      children: grouped.entries.map((e) {
                        return _ShowTimesSection(
                          cinemaTitle: e.key,
                          times: e.value.map((x) => x['time'] ?? '').toList(),
                          onTapTime: (t) {
                            final cinema = e.value.first['cinema'] ?? '';
                            final lang = e.value.first['language'] ?? '';
                            _openSeats(cinema: cinema, language: lang, time: t);
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
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(icon: Icons.category_outlined, title: 'LANGUAGE', value: language),
                  const SizedBox(height: 12),
                  _DetailRow(icon: Icons.access_time, title: 'DURATION', value: duration),
                  const SizedBox(height: 12),
                  _DetailRow(icon: Icons.description_outlined, title: 'SYNOPSIS', value: description),
                ],
              ),
            ),
          ),
        ],
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
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: fg),
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

  const _ChipButton({required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade800 : Colors.grey.shade200,
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

class _ShowTimesSection extends StatelessWidget {
  final String cinemaTitle;
  final List<String> times;
  final Function(String) onTapTime;

  const _ShowTimesSection({
    required this.cinemaTitle,
    required this.times,
    required this.onTapTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(cinemaTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: times.map((t) {
              return ElevatedButton(
                onPressed: () => onTapTime(t),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
