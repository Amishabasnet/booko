import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:booko/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:booko/features/auth/presentation/pages/login_screen.dart';
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

  Widget createLoginScreen() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('Login screen has email and password fields and login button', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('should show error message when email is empty and login is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
  });
}
