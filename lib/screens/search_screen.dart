import 'package:flutter/material.dart';
import 'package:booko/widgets/movie_list_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie, Genres & Language',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text('Clear', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          MovieListItem(
            imagePath: 'assets/images/wicked.jpg',
            title: 'Wicked: For Good',
          ),
          MovieListItem(
            imagePath: 'assets/images/man_binako_dhan.jpg',
            title: 'Man Binako Dhan',
          ),
          MovieListItem(
            imagePath: 'assets/images/predator.jpg',
            title: 'Predator: Badlands',
          ),
          MovieListItem(imagePath: 'assets/images/paran.jpg', title: 'Paran'),
        ],
      ),
    );
  }
}
