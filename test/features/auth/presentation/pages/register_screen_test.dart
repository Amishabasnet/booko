import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:booko/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:booko/features/auth/presentation/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createRegisterScreen() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: const MaterialApp(
        home: RegisterScreen(),
      ),
    );
  }

  testWidgets('Register screen has required fields and sign up button', (WidgetTester tester) async {
    await tester.pumpWidget(createRegisterScreen());

    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    
    // There might be multiple "Password" texts (label and hint)
    expect(find.text('Password'), findsAtLeastNWidgets(1));
    expect(find.text('Confirm Password'), findsAtLeastNWidgets(1));
    
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('should show errors on empty submission', (WidgetTester tester) async {
    await tester.pumpWidget(createRegisterScreen());

    final signUpButton = find.text('Create Account');
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pump();

    expect(find.text('Required.'), findsOneWidget);
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(find.text('Phone number must be 10 digits.'), findsOneWidget);
    expect(find.text('Please select your birth date.'), findsOneWidget);
    expect(find.text('Please select gender.'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters.'), findsOneWidget);
  });
}
