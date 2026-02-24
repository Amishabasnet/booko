import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class WatchNowShowing {
  final MovieRepository repo;
  WatchNowShowing(this.repo);

  Stream<List<Movie>> call() => repo.watchNowShowing();
}

class WatchComingSoon {
  final MovieRepository repo;
  WatchComingSoon(this.repo);

  Stream<List<Movie>> call() => repo.watchComingSoon();
}
