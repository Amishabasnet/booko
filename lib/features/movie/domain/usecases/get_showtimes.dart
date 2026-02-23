import '../entities/showtime.dart';
import '../repositories/movie_repository.dart';

class GetShowtimes {
  final MovieRepository repo;
  GetShowtimes(this.repo);

  Future<List<Showtime>> call(String movieId) => repo.getShowtimes(movieId);
}
