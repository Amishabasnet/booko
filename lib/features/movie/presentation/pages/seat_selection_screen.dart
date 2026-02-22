import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  final String movieTitle;
  final String cinema;
  final String time;
  final String dateLabel;

  const SeatSelectionScreen({
    super.key,
    required this.movieTitle,
    required this.cinema,
    required this.time,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Seats'), centerTitle: true),
      body: Center(
        child: Text(
          '$movieTitle\n$cinema\n$dateLabel • $time',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
