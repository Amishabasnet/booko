import 'package:booko/features/offers/presentation/offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Offer screen should list offers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OfferScreen(),
        ),
      ),
    );

    expect(find.text('Exclusive Offers'), findsOneWidget);
    expect(find.text('50% Off on Movies'), findsOneWidget);
    expect(find.text('Buy 1 Get 1 Free'), findsOneWidget);
  });
}
