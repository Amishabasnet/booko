import 'package:booko/features/search/domain/entities/movie.dart';
import 'package:booko/features/search/domain/repositories/search_repository.dart';
import 'package:booko/features/search/domain/usecases/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late SearchMovies useCase;
  late MockSearchRepository mockRepo;

  setUp(() {
    mockRepo = MockSearchRepository();
    useCase = SearchMovies(mockRepo);
  });

  final tMovie = Movie(
    id: '1',
    title: 'Action Movie',
    language: 'English',
    genres: ['Action'],
    posterUrl: 'url',
  );
  final List<Movie> tMovies = [tMovie];

  test('should get movies from repository for a given query', () async {
    // arrange
    when(() => mockRepo.search(any())).thenAnswer((_) async => tMovies);

    // act
    final result = await useCase('Action');

    // assert
    expect(result, tMovies);
    verify(() => mockRepo.search('Action')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
