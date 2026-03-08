import 'package:booko/features/movie/data/models/ticket_hive_model.dart';
import 'package:booko/features/profile/data/models/ticket_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:booko/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booko/core/api/api_endpoints.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:booko/features/profile/data/models/profile_hive_model.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String movieTitle;
  final String movieId;
  final String cinema;
  final String time;
  final String dayText; // Date of booking
  final List<String> seats; // List of selected seats
  final int totalPrice;
  final String eventDate; // Movie date (the date movie is booked for)

  final ValueNotifier<bool> _isBookingNotifier = ValueNotifier<bool>(false);

  BookingConfirmationScreen({
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
                backgroundColor: Colors.green.shade400,
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

            // Top Information
            _buildTopInformation(),
            const SizedBox(height: 20),

            // Movie Details
            Text(
              movieTitle,
              style: const TextStyle(
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
              'Movie Date: $eventDate',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Ticket Details
            _buildTicketDetail('Tickets ${seats.length}', 'NPR $totalPrice'),
            const SizedBox(height: 10),
            _buildTicketDetail(
              'Total Payable',
              'NPR $totalPrice',
              isBold: true,
            ),

            const Spacer(),

            // Checkout Button
            ValueListenableBuilder<bool>(
              valueListenable: _isBookingNotifier,
              builder: (context, isBooking, _) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isBooking
                        ? null
                        : () => _handleCheckout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isBooking
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'CHECKOUT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HANDLE CHECKOUT ----------------
  void _handleCheckout(BuildContext context) async {
    _isBookingNotifier.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final uri = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.bookTicket}',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'movieTitle': movieTitle,
          'movieId': movieId,
          'cinema': cinema,
          'time': time,
          'date': dayText,
          'seats': seats,
          'totalPrice': totalPrice,
        }),
      );

      _isBookingNotifier.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ---------------- SAVE TICKET TO PROFILE ----------------
        final profileBox = Hive.box<ProfileHiveModel>('profileBox');
        if (profileBox.isNotEmpty) {
          final profile = profileBox.getAt(0)!; // assuming single user
          final ticket = TicketModel(
            movieTitle: movieTitle,
            movieId: movieId,
            cinema: cinema,
            time: time,
            dayText: dayText,
            seats: seats,
            totalPrice: totalPrice,
            eventDate: eventDate,
          );

          // Add ticket to existing list
          profile.myTickets.add(ticket as TicketHiveModel);
          profile.save();
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed! Ticket added to My Tickets'),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardHome()),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to book: ${response.body}')),
          );
        }
      }
    } catch (e) {
      _isBookingNotifier.value = false;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error booking: $e')));
      }
    }
  }

  // ---------------- UI HELPERS ----------------
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
