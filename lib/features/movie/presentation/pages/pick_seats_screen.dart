import 'package:flutter/material.dart';

import 'booking_confirmation_screen.dart';

class PickSeatsScreen extends StatefulWidget {
  final String movieTitle;
  final String movieId;
  final String cinema;
  final String time;
  final int dayIndex;

  const PickSeatsScreen({
    super.key,
    required this.movieTitle,
    required this.movieId,
    required this.cinema,
    required this.time,
    required this.dayIndex,
  });

  @override
  State<PickSeatsScreen> createState() => _PickSeatsScreenState();
}

class _PickSeatsScreenState extends State<PickSeatsScreen> {
  final Set<String> _selectedSeats = {};
  static const int _pricePerSeat = 300;

  String _seatLabel(int r, int c) {
    final row = String.fromCharCode(65 + r);
    return '$row$c';
  }

  int get _totalPrice => _selectedSeats.length * _pricePerSeat;

  @override
  Widget build(BuildContext context) {
    final dayText = widget.dayIndex == 0 ? 'Today' : 'Tomorrow';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'PICK YOUR SEATS',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'SCREEN THIS WAY',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
          const SizedBox(height: 14),

          Expanded(
            child: Center(
              child: SizedBox(
                width: 320,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  itemCount: 10 * 10,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (_, i) {
                    final r = i ~/ 10;
                    final c = (i % 10) + 1;
                    final seat = _seatLabel(r, c);

                    final isSelected = _selectedSeats.contains(seat);

                    return InkWell(
                      onTap: () {
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
                          color: isSelected ? Colors.red : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Text(
                          seat,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _Legend(color: Colors.orange, text: 'SELECTED'),
                SizedBox(width: 16),
                _Legend(color: Colors.grey, text: 'AVAILABLE'),
                SizedBox(width: 16),
                _Legend(color: Colors.red, text: 'BOOKED'),
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
                    children: [
                      Text(
                        _selectedSeats.isEmpty
                            ? 'No seats selected'
                            : 'Seats: ${_selectedSeats.join(", ")}',
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'TOTAL: Rs. $_totalPrice',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
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
                                  seats: _selectedSeats.toList(),
                                  totalPrice: _totalPrice,
                                ),
                              ),
                            );
                          },
                    child: const Text(
                      'NEXT',
                      style: TextStyle(fontWeight: FontWeight.w800),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
