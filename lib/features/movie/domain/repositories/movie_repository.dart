import '../entities/movie.dart';
import '../entities/showtime.dart';

abstract class MovieRepository {
  Future<Movie?> getMovieById(String id);
  Future<List<Showtime>> getShowtimes(String movieId);
}
