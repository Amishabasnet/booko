import 'package:booko/features/movie/domain/repositories/movie_repository.dart';
import 'package:booko/features/movie/domain/usecases/get_movie.dart';
import 'package:booko/features/movie/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetMovie useCase;
  late MockMovieRepository mockRepo;

  setUp(() {
    mockRepo = MockMovieRepository();
    useCase = GetMovie(mockRepo);
  });

  const tMovie = Movie(
    id: '1',
    title: 'Test Movie',
    posterPath: '/path',
    language: 'English',
    duration: '2h',
    description: 'Desc',
    isComingSoon: false,
    showtimes: [],
  );

  test('should get movie from repository', () async {
    // arrange
    when(() => mockRepo.getMovie(any())).thenAnswer((_) async => tMovie);

    // act
    final result = await useCase('1');

    // assert
    expect(result, tMovie);
    verify(() => mockRepo.getMovie('1')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
