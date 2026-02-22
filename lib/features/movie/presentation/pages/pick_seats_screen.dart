import 'package:booko/features/movie/presentation/pages/booking_confirmation.dart';
import 'package:flutter/material.dart';

enum SeatStatus { available, selected, booked }

class PickSeatsScreen extends StatefulWidget {
  final String movieTitle;
  final String cinema;
  final String dateLabel;
  final String time;
  final int seatPrice;

  const PickSeatsScreen({
    super.key,
    required this.movieTitle,
    required this.cinema,
    required this.dateLabel,
    required this.time,
    this.seatPrice = 250,
  });

  @override
  State<PickSeatsScreen> createState() => _PickSeatsScreenState();
}

class _PickSeatsScreenState extends State<PickSeatsScreen> {
  final List<String> rows = const [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
  ];
  final int seatsPerRow = 9;

  // ✅ STATIC booked seats (later you can replace with Hive by showtimeId)
  final Set<String> booked = {'A2', 'C7', 'D4', 'F1', 'F2', 'H9'};

  // ✅ Selected seats (user)
  final Set<String> selected = {};

  String _seatId(String row, int index) => '$row$index';

  void _toggleSeat(String id) {
    if (booked.contains(id)) return;

    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }
    });
  }

  int get total => selected.length * widget.seatPrice;

  void _goToConfirmation() {
    if (selected.isEmpty) return;

    final seats = selected.toList()..sort();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          movieTitle: widget.movieTitle,
          cinema: widget.cinema,
          dateLabel: widget.dateLabel,
          time: widget.time,
          seats: seats,
          seatPrice: widget.seatPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PICK YOUR SEATS',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ✅ Screen direction indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SCREEN THIS WAY',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // ✅ Seat Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  // ✅ Show info line (movie/cinema/time)
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

                  ...rows.map((r) => _seatRow(r)).toList(),

                  const SizedBox(height: 18),

                  // ✅ Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendBox(
                        color: Colors.amber.shade600,
                        label: 'SELECTED',
                      ),
                      const SizedBox(width: 12),
                      _legendBox(
                        color: Colors.grey.shade400,
                        label: 'AVAILABLE',
                      ),
                      const SizedBox(width: 12),
                      _legendBox(color: Colors.red.shade600, label: 'BOOKED'),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ✅ Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xff0B2A43),
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selected.isEmpty
                            ? 'No seats selected'
                            : selected.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TOTAL: Rs. $total',
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
                    onPressed: selected.isEmpty ? null : _goToConfirmation,
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

  Widget _seatRow(String row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(seatsPerRow, (i) {
          final seatNo = i + 1;
          final id = _seatId(row, seatNo);

          final SeatStatus status = booked.contains(id)
              ? SeatStatus.booked
              : (selected.contains(id)
                    ? SeatStatus.selected
                    : SeatStatus.available);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => _toggleSeat(id),
              child: _seatBox(id: id, status: status),
            ),
          );
        }),
      ),
    );
  }

  Widget _seatBox({required String id, required SeatStatus status}) {
    Color border;
    Color fill;
    Color textColor;

    switch (status) {
      case SeatStatus.selected:
        border = Colors.amber.shade700;
        fill = Colors.amber.shade600;
        textColor = Colors.black;
        break;
      case SeatStatus.booked:
        border = Colors.red.shade700;
        fill = Colors.red.shade600;
        textColor = Colors.white;
        break;
      case SeatStatus.available:
      default:
        border = Colors.grey.shade600;
        fill = Colors.transparent;
        textColor = Colors.black87;
        break;
    }

    return Container(
      width: 28,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        id,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _legendBox({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
