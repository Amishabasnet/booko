import 'package:booko/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Onboarding screen should show welcome text first', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to BOOKO'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next button should navigate through onboarding pages', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Initial page
    expect(find.text('Welcome to BOOKO'), findsOneWidget);

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Second page
    expect(find.text('Book Your Favorite Movies'), findsOneWidget);

    // Tap Next again
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Third page should show "Get Started"
    expect(find.text('Fast & Easy Experience'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
