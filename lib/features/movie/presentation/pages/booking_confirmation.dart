import 'package:flutter/material.dart';
import 'booking_success_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String movieTitle;
  final String cinema;
  final String dateLabel;
  final String time;
  final List<String> seats;
  final int seatPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.movieTitle,
    required this.cinema,
    required this.dateLabel,
    required this.time,
    required this.seats,
    required this.seatPrice,
  });

  int get total => seats.length * seatPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _infoRow('Cinema', cinema),
                  _infoRow('Show', '$dateLabel • $time'),
                  _infoRow('Seats', seats.join(', ')),
                  _infoRow('Price/Seat', 'Rs. $seatPrice'),
                  const Divider(height: 20),
                  _infoRow(
                    'Total',
                    'Rs. $total',
                    valueStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff0B2A43),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Please verify your details before confirming.\nOnce confirmed, seats will be reserved.',
                style: TextStyle(color: Colors.white, height: 1.35),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingSuccessScreen(
                        movieTitle: movieTitle,
                        cinema: cinema,
                        dateLabel: dateLabel,
                        time: time,
                        seats: seats,
                        total: total,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
