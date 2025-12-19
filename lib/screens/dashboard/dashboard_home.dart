import 'package:flutter/material.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  final List<Map<String, String>> nowShowing = const [
    {
      'title': 'Predator: Badlands',
      'image': 'assets/images/predator-badlands.jpg',
      'language': 'English',
      'duration': '1h 45m',
    },
    {
      'title': 'Paran',
      'image': 'assets/images/paran.jpg',
      'language': 'Nepali',
      'duration': '1h 50m',
    },
    {
      'title': 'Man Binako Dhan',
      'image': 'assets/images/manbinakodhan.jpg',
      'language': 'Nepali',
      'duration': '2h 5m',
    },
    {
      'title': 'The Running Man',
      'image': 'assets/images/runningman.jpg',
      'language': 'English',
      'duration': '2h 0m',
    },
    {
      'title': 'Wicked: For Good',
      'image': 'assets/images/wicked.jpg',
      'language': 'English',
      'duration': '1h 55m',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Booko',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.indigo[900],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'NOW SHOWING'),
              Tab(text: 'COMING SOON'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: nowShowing.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = nowShowing[index];
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            movie['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${movie['language']} | ${movie['duration']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Center(child: Text('Coming Soon Movies')),
          ],
        ),
      ),
    );
  }
}
