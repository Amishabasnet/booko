import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, String>> nowShowing = const [
    {
      'title': 'Predator:Badlands',
      'image': 'assets/icons/images/predator-badlands.jpg',
      'language': 'English',
      'duration': '1h 45m',
    },
    {
      'title': 'Paran',
      'image': 'assets/icons/images/paran.jpg',
      'language': 'Nepali',
      'duration': '1h 50m',
    },
    {
      'title': 'Man Binako Dhan',
      'image': 'assets/icons/images/manbinakodhan.jpg',
      'language': 'Nepali',
      'duration': '2h 5m',
    },
    {
      'title': 'The Running Man',
      'image': 'assets/icons/images/runningman.jpg',
      'language': 'English',
      'duration': '2h 0m',
    },
    {
      'title': 'Wicked: For Good',
      'image': 'assets/icons/images/wicked.jpg',
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
          title: const Text('Booko'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            movie['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          movie['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${movie['language']}   |  ${movie['duration']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Center(child: Text('Coming Soon Movies here')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.tag), label: 'Offers'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedItemColor: Colors.indigo[900],
        ),
      ),
    );
  }
}
