import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booko/core/api/api_endpoints.dart';
import 'booking_confirmation_screen.dart';

enum SeatStatus { available, selected, booked }

class PickSeatsScreen extends StatefulWidget {
  final String movieTitle;
  final String movieId;
  final String cinema;
  final String time;
  final int dayIndex;
  final String dateLabel;
  final int seatPrice;

  const PickSeatsScreen({
    super.key,
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayIndex,
    required this.dateLabel,
    this.seatPrice = 250,
  });

  @override
  State<PickSeatsScreen> createState() => _PickSeatsScreenState();
}

class _PickSeatsScreenState extends State<PickSeatsScreen> {
  final List<String> rows = const ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  final int seatsPerRow = 10;
  final Set<String> _selectedSeats = {};
  Set<String> _bookedSeats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedSeats();
  }

  Future<void> _fetchBookedSeats() async {
    try {
      final dayText = widget.dayIndex == 0 ? 'Today' : 'Tomorrow';
      final uri = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getBookedSeats}?movieId=${widget.movieId}&cinema=${widget.cinema}&time=${widget.time}&date=$dayText',
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> seatList = decoded['data'];
          setState(() {
            _bookedSeats = seatList.map((e) => e.toString()).toSet();
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching seats: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  String _seatLabel(int r, int c) {
    final row = rows[r];
    return '$row$c';
  }

  int get _totalPrice => _selectedSeats.length * widget.seatPrice;

  @override
  Widget build(BuildContext context) {
    final dayText = widget.dayIndex == 0 ? 'Today' : 'Tomorrow';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'PICK YOUR SEATS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SCREEN THIS WAY',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '${widget.movieTitle} • ${widget.cinema}\n${widget.dateLabel} • ${widget.time}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 320,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rows.length * seatsPerRow,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                          ),
                          itemBuilder: (_, i) {
                            final r = i ~/ seatsPerRow;
                            final c = (i % seatsPerRow) + 1;
                            final seat = _seatLabel(r, c);

                            final isBooked = _bookedSeats.contains(seat);
                            final isSelected = _selectedSeats.contains(seat);

                            Color bgColor = Colors.white;
                            Color textColor = Colors.black87;
                            Color borderColor = Colors.black26;

                            if (isBooked) {
                              bgColor = Colors.red.shade600;
                              textColor = Colors.white;
                              borderColor = Colors.red.shade700;
                            } else if (isSelected) {
                              bgColor = Colors.orange.shade600;
                              textColor = Colors.white;
                              borderColor = Colors.orange.shade700;
                            }

                            return InkWell(
                              onTap: isBooked
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedSeats.remove(seat);
                                        } else {
                                          _selectedSeats.add(seat);
                                        }
                                      });
                                    },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  seat,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Legend(color: Colors.orange.shade600, text: 'SELECTED'),
                const SizedBox(width: 16),
                _Legend(color: Colors.grey.shade400, text: 'AVAILABLE'),
                const SizedBox(width: 16),
                _Legend(color: Colors.red.shade600, text: 'BOOKED'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            color: Colors.indigo.shade900,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedSeats.isEmpty
                            ? 'No seats selected'
                            : 'Seats: ${_selectedSeats.join(", ")}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TOTAL: Rs. $_totalPrice',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectedSeats.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingConfirmationScreen(
                                  movieTitle: widget.movieTitle,
                                  movieId: widget.movieId,
                                  cinema: widget.cinema,
                                  time: widget.time,
                                  dayText: dayText,
                                  seats: _selectedSeats.toList()..sort(),
                                  totalPrice: _totalPrice,
                                  eventDate: widget.dateLabel,
                                ),
                              ),
                            );
                          },
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
