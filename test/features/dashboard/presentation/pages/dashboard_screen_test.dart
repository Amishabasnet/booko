import 'package:booko/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:booko/features/movie/domain/repositories/movie_repository.dart';
import 'package:booko/features/movie/presentation/providers/movie_providers.dart';
import 'package:booko/features/search/presentation/providers/search_provider.dart';
import 'package:booko/features/search/domain/usecases/search_movies.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}
class MockSearchMoviesUsecase extends Mock implements SearchMovies {}
class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockMovieRepository mockMovieRepo;
  late MockSearchMoviesUsecase mockSearchMovies;
  late MockUserSessionService mockSession;

  setUp(() {
    mockMovieRepo = MockMovieRepository();
    mockSearchMovies = MockSearchMoviesUsecase();
    mockSession = MockUserSessionService();

    when(() => mockMovieRepo.watchNowShowing()).thenAnswer((_) => Stream.value([]));
    when(() => mockMovieRepo.watchComingSoon()).thenAnswer((_) => Stream.value([]));
    
    when(() => mockSession.getName()).thenAnswer((_) async => 'Test');
    when(() => mockSession.getEmail()).thenAnswer((_) async => 'test@test.com');
    when(() => mockSession.getPhoneNumber()).thenAnswer((_) async => '123');
    when(() => mockSession.getDob()).thenAnswer((_) async => '01/01/2000');
    when(() => mockSession.getGender()).thenAnswer((_) async => 'Male');
  });

  testWidgets('Dashboard screen should have bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(mockMovieRepo),
          searchMoviesUsecaseProvider.overrideWithValue(mockSearchMovies),
          UserSessionServiceProvider.overrideWithValue(mockSession),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
