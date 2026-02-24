import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String movieTitle;
  final String cinema;
  final String dateLabel;
  final String time;
  final List<String> seats;
  final int total;

  const BookingSuccessScreen({
    super.key,
    required this.movieTitle,
    required this.cinema,
    required this.dateLabel,
    required this.time,
    required this.seats,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booked'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 72),
            const SizedBox(height: 12),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),

            Text(
              '$movieTitle\n$cinema\n$dateLabel • $time\nSeats: ${seats.join(', ')}\nTotal: Rs. $total',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  'Go Home',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
