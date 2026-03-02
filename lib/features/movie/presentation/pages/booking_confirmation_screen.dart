import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String movieTitle;
  final String movieId;
  final String cinema;
  final String time;
  final String dayText; // Date of booking
  final List<String> seats; // List of selected seats
  final int totalPrice;
  final String eventDate; // Movie date (the date movie is booked for)

  const BookingConfirmationScreen({
    super.key,
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayText, // Booking date
    required this.seats,
    required this.totalPrice,
    required this.eventDate, // Movie booked date
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon and Message
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.check, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: const Text(
                'Ticket Booking Confirmation',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Top Information: Time Slot, Audi No., and Seat
            _buildTopInformation(),
            const SizedBox(height: 20),

            // Movie, Date, and Cinema
            Text(
              movieTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$cinema - $dayText',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Movie Date: $eventDate', // Display the movie date (when booked)
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Ticket Details (Number of tickets)
            _buildTicketDetail('Ticket ${seats.length}', 'NPR $totalPrice'),
            const SizedBox(height: 10),
            _buildTicketDetail(
              'Total Payable',
              'NPR $totalPrice',
              isBold: true,
            ),

            const Spacer(),

            // Checkout Button at the bottom
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking confirmed')),
                  );
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build top information (Time Slot, Audi No., Seat)
  Widget _buildTopInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard('TIME SLOT', time),
        _buildInfoCard('AUDI NO.', 'AUDI 3'),
        _buildInfoCard('SEAT', seats.join(', ')),
      ],
    );
  }

  // Function to build individual info card
  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Function to create a ticket detail row (Ticket X, Total Payable)
  Widget _buildTicketDetail(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
