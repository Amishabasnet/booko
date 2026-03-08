import 'package:flutter_riverpod/legacy.dart';

final bookedSeatsProvider =
    StateNotifierProvider<BookedSeatsNotifier, Map<String, List<String>>>(
      (ref) => BookedSeatsNotifier(),
    );

class BookedSeatsNotifier extends StateNotifier<Map<String, List<String>>> {
  BookedSeatsNotifier() : super({});

  String _getKey(String movieId, String cinema, String time) =>
      '$movieId-$cinema-$time';

  List<String> getBookedSeats(String movieId, String cinema, String time) {
    return state[_getKey(movieId, cinema, time)] ?? [];
  }

  void bookSeat(String movieId, String cinema, String time, String seatNumber) {
    final key = _getKey(movieId, cinema, time);
    final currentSeats = state[key] ?? [];
    if (!currentSeats.contains(seatNumber)) {
      state = {
        ...state,
        key: [...currentSeats, seatNumber],
      };
    }
  }
}
