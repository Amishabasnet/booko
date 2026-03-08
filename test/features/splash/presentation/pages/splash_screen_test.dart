import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockService;

  setUp(() {
    mockService = MockUserSessionService();
  });

  testWidgets('Splash screen should render movie ticket image', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          UserSessionServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    
    // Exhaust the splash timer to avoid "A Timer is still pending" error
    await tester.pump(const Duration(seconds: 4));
  });
}
