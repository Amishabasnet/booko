import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String movieTitle;
  final String movieId;
  final String cinema;
  final String time;
  final String dayText;
  final List<String> seats;
  final int totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayText,
    required this.seats,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),

            _row('Movie', movieTitle),
            _row('Day', dayText),
            _row('Cinema', cinema),
            _row('Time', time),
            _row('Seats', seats.join(', ')),
            const Divider(height: 24),
            _row('Total', 'Rs. $totalPrice'),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking confirmed (demo)')),
                  );
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$k:',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
