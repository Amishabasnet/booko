import 'package:booko/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DashboardHome should display movie tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardHome(),
      ),
    );

    expect(find.text('NOW SHOWING'), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
    
    // Check if some movie titles from the static list are rendered
    expect(find.text('Predator: Badlands'), findsOneWidget);
  });
}
