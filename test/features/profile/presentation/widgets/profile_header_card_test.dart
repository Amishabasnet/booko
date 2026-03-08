import 'package:booko/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileHeaderCard should display name and respond to edit', (WidgetTester tester) async {
    bool editClicked = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileHeaderCard(
            name: 'Test User',
            onEdit: () {
              editClicked = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('WELCOME BACK'), findsOneWidget);
    expect(find.text('TEST USER'), findsOneWidget); // Card converts to uppercase
    
    // Tap edit button
    await tester.tap(find.byIcon(Icons.edit));
    expect(editClicked, isTrue);
  });
}
