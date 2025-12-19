import 'package:flutter/material.dart';
import 'package:booko/widgets/movie_list_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Screen',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
